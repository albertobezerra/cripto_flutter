import 'package:criptos/database/db.dart';
import 'package:criptos/models/moedas.dart';
import 'package:criptos/repositorios/moedas_repositorio.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/posicao.dart';

class ContaRepositorio extends ChangeNotifier {
  late Database db;
  late List<Posicao> _carteira = [];
  double _saldo = 0;

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;

  ContaRepositorio() {
    _initRepositorio();
  }
  _initRepositorio() async {
    await _getSaldo();
    await _getCarteira();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    if (conta.isNotEmpty) {
      _saldo = conta.first['saldo'];
    } else {
      // Define um valor padrão se a consulta não retornar resultados
      _saldo = 0;
      // Opcionalmente, você pode inserir um registro inicial na tabela `conta`
      await db.insert('conta', {'saldo': _saldo});
    }
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;
    await db.update('conta', {
      'saldo': valor,
    });
    _saldo = valor;
    notifyListeners();
  }

  comprar(Moedas moeda, double valor) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      // verificar se a moeda ja foi comprada antes
      final posicaoMoeda = await txn.query(
        'carteira',
        where: 'sigla = ?',
        whereArgs: [moeda.sigla],
      );
      // se não tem na carteira
      if (posicaoMoeda.isEmpty) {
        await txn.insert('carteira', {
          'sigla': moeda.sigla,
          'moeda': moeda.nome,
          'quantidade': (valor / moeda.preco).toString()
        });
      } else {
        final atual = double.parse(posicaoMoeda.first['quantidade'].toString());
        await txn.update(
          'carteira',
          {
            'quantidade': (atual + (valor / moeda.preco)).toString(),
          },
          where: 'sigla = ?',
          whereArgs: [moeda.sigla],
        );
      }

      // Inserir a compra no historico
      await txn.insert(
        'historico',
        {
          'sigla': moeda.sigla,
          'moeda': moeda.nome,
          'quantidade': (valor / moeda.preco).toString(),
          'valor': valor,
          'tipo_operacao': 'compra',
          'data_operacao': DateTime.now().millisecondsSinceEpoch
        },
      );

      // Atualizar o saldo
      await txn.update('conta', {'saldo': saldo - valor});
    });
    await _initRepositorio();
    notifyListeners();
  }

  _getCarteira() async {
    _carteira = [];
    List posicoes = await db.query('carteira');
    for (var posicao in posicoes) {
      Moedas moeda = MoedaRepositorio.tabela.firstWhere(
        (m) => m.sigla == posicao['sigla'],
      );
      _carteira.add(Posicao(
        moeda: moeda,
        quantidade: double.parse(posicao['quantidade']),
      ));
    }
    notifyListeners();
  }
}
