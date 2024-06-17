import 'package:criptos/repositorios/favoritas.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meu_aplicativo.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => Favoritas(),
      child: const MeuAplicativo(),
    ),
  );
}
