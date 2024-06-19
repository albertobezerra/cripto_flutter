import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AppSettings extends ChangeNotifier {
   SharedPreferences prefs;
    Map<String, String> locale = {
      'locale': 'pt_BR',
      'name': 'R\$'
    };

    //oremos
  
}
