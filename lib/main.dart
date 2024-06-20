import 'package:criptos/configs/app_settings.dart';
import 'package:criptos/configs/hive_configs.dart';
import 'package:criptos/repositorios/favoritas_repositorio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'meu_aplicativo.dart';

void main() async {

  /* No Flutter, a função WidgetsFlutterBinding.ensureInitialized() é usada para 
  garantir que a ligação dos widgets seja inicializada corretamente antes 
  de executar qualquer código que dependa do framework do Flutter. 
  Isso é especialmente importante quando você precisa acessar 
  serviços ou recursos que dependem do contexto do Flutter, 
  como o sistema de plugins ou a inicialização de bibliotecas específicas. */

  WidgetsFlutterBinding.ensureInitialized();
  await HiveConfig.start();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => AppSettings()
      ),
      ChangeNotifierProvider(
        create: (context) => Favoritas()
      )
    ],
    child: const MeuAplicativo(),
  ));
}
