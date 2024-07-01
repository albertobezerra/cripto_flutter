import 'package:criptos/models/moedas.dart';

class Historico {
  DateTime dataOperacao;
  String tipoOpreracao;
  Moedas moeda;
  double valor;
  double quantidade;

  Historico({
    required this.dataOperacao,
    required this.tipoOpreracao,
    required this.moeda,
    required this.valor,
    required this.quantidade,
  });
}
