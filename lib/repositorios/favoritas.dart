import 'dart:collection';

import 'package:criptos/models/moedas.dart';
import 'package:flutter/material.dart';

// ChangeNotifier ele que informar ao flutter para redesenhar a tela
class Favoritas extends ChangeNotifier {
  final List<Moedas> _lista = [];

  UnmodifiableListView<Moedas> get lista => UnmodifiableListView(_lista);
}
