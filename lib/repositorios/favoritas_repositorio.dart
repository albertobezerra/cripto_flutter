import 'dart:collection';

import 'package:criptos/models/moedas.dart';
import 'package:flutter/material.dart';

// ChangeNotifier ele que informar ao flutter para redesenhar a tela
class Favoritas extends ChangeNotifier {
  final List<Moedas> _lista = [];

  UnmodifiableListView<Moedas> get lista => UnmodifiableListView(_lista);

  saveAll(List<Moedas> moedas) {
    for (var moeda in moedas) {
      if (!_lista.contains(moeda)) _lista.add(moeda);
    }
    notifyListeners();
  }

  remove(Moedas moeda) {
    _lista.remove(moeda);
    notifyListeners();
  }
}
