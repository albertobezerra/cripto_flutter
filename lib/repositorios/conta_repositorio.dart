import 'package:criptos/database/db.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../models/posicao.dart';

class ContaRepositorio extends ChangeNotifier{
  late Database db;
  final List<Posicao> _carteira = [];
  double _saldo = 0;

  get saldo => _saldo;
  List<Posicao> get carteira => _carteira;

  ContaRepositorio(){
    _initRepositorio();
  }
  _initRepositorio() async{
    await _getSaldo();
  }

  _getSaldo() async{
    db = await DB.instance.database;
    List conta = await db.query('conta', limit: 1);
    _saldo = conta.first['saldo'];
    notifyListeners();
  }

  setSaldo(double valor) async{
    db = await DB.instance.database;
    db.update('conta', {
      'saldo' : valor,
    });
    _saldo = valor;
    notifyListeners();
  }
}