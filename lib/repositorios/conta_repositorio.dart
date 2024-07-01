import 'package:criptos/database/db.dart';
import 'package:criptos/models/moedas.dart';
import 'package:criptos/repositorios/moedas_repositorio.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/historico.dart';
import '../models/posicao.dart';

class ContaRepositorio extends ChangeNotifier {
  late Database db;
  late final List<Posicao> _carteira = [];
  late final List<Historico> _historico = [];
  double _saldo = 0;

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;
  List<Historico> get historico => _historico;

  ContaRepositorio() {
    _initRepositorio();
  }

  _initRepositorio() async {
    await _getSaldo();
    await _getCarteira();
    await _getHistorico();
  }

  _getSaldo() async {
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    if (conta.isNotEmpty) {
      _saldo = conta.first['saldo'];
    } else {
      _saldo = 0;
      await db.insert('conta', {'saldo': _saldo});
    }
    notifyListeners();
  }

  setSaldo(double valor) async {
    db = await DB.instance.database;
    await db.update('conta', {'saldo': valor});
    _saldo = valor;
    notifyListeners();
  }

  comprar(Moedas moeda, double valor) async {
    db = await DB.instance.database;
    await db.transaction((txn) async {
      final posicaoMoeda = await txn.query(
        'carteira',
        where: 'sigla = ?',
        whereArgs: [moeda.sigla],
      );
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
          {'quantidade': (atual + (valor / moeda.preco)).toString()},
          where: 'sigla = ?',
          whereArgs: [moeda.sigla],
        );
      }

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

      await txn.update('conta', {'saldo': _saldo - valor});
    });
    await _initRepositorio();
    notifyListeners();
  }

  _getCarteira() async {
    _carteira.clear();
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

  _getHistorico() async {
    _historico.clear();
    List operacoes = await db.query('historico');
    for (var operacao in operacoes) {
      Moedas moeda = MoedaRepositorio.tabela.firstWhere(
        (m) => m.sigla == operacao['sigla'],
      );
      _historico.add(Historico(
        dataOperacao:
            DateTime.fromMillisecondsSinceEpoch(operacao['data_operacao']),
        tipoOpreracao: operacao['tipo_operacao'],
        moeda: moeda,
        valor: operacao['valor'],
        quantidade: double.parse(operacao['quantidade']),
      ));
    }
    notifyListeners();
  }
}
