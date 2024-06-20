import 'dart:collection';

import 'package:criptos/models/moedas.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../adapters/moeda_hive_adapters.dart';

// ChangeNotifier ele que informar ao flutter para redesenhar a tela
class Favoritas extends ChangeNotifier {
  final List<Moedas> _lista = [];
  late LazyBox box;

  Favoritas(){
    _starRepository();
  }

  _starRepository() async {
    await _openBox();
    await _readFavoritas();
  }

  _openBox()async{
    Hive.registerAdapter(MoedaHiveAdapter());
    box = await Hive.openLazyBox<Moedas>('moedas_favoritas');
  }

  _readFavoritas()async{
    var keys = box.keys.toList();
    for (var moeda in keys) {
    Moedas m = await box.get(moeda);
    _lista.add(m);
     }
     notifyListeners();
  }

  UnmodifiableListView<Moedas> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moedas> moedas) {
    for (var moeda in moedas) {
      if (!_lista.any((atual)=> atual.sigla == moeda.sigla)){
        _lista.add(moeda);
        box.put(moeda.sigla, moeda);
      }
    }
    notifyListeners();
  }

  remove(Moedas moeda) {
    _lista.remove(moeda);
    box.delete(moeda.sigla);
    notifyListeners();
  }
}
