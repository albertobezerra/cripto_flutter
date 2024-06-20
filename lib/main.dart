import 'package:criptos/configs/app_settings.dart';
import 'package:criptos/repositorios/favoritas_repositorio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meu_aplicativo.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => Favoritas()
      ),
      ChangeNotifierProvider(
        create: (context) => AppSettings()
      )
    ],
    child: const MeuAplicativo(),
  ));
}
