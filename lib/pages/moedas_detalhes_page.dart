import 'package:flutter/material.dart';
import 'package:criptos/models/moedas.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../configs/app_settings.dart';

class MoedaDetalhesPage extends StatefulWidget {
  final Moedas moeda;

  const MoedaDetalhesPage({super.key, required this.moeda});

  @override
  State<MoedaDetalhesPage> createState() => _MoedaDetalhesPageState();
}

class _MoedaDetalhesPageState extends State<MoedaDetalhesPage> {
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  // usa a barra invertidar para o $ ser conhecido como texto.
  final _form = GlobalKey<FormState>();
  // usando assim o sistema já cria uma chave aleatória para o formulario
  final _valor = TextEditingController();
  // serve para pegar o texto inserido no campo.
  double quantidade = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var locale = context.watch<AppSettings>().locale;
    real = NumberFormat.currency(locale: locale['locale'], name: locale['name']);
  }

  comprar() {
    if (_form.currentState!.validate()) {
      //salvar a compra
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Compra realizada com sucesso!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.amber,
          title: Text(widget.moeda.nome),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      child: Image.asset(widget.moeda.icone),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      real.format(widget.moeda.preco),
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -1,
                          color: Colors.grey[800]),
                    )
                  ],
                ),
              ),
              (quantidade > 0)
                  ? SizedBox(
                      width: MediaQuery.of(context).size.width,
                      // assim ele fica do tamanho da coluna com base na tela.
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(bottom: 24),
                        child: Text(
                          '$quantidade ${widget.moeda.sigla}',
                          style: const TextStyle(
                            fontSize: 26,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.only(bottom: 24),
                    ),
              Form(
                key: _form,
                child: TextFormField(
                  controller: _valor,
                  style: const TextStyle(fontSize: 22),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Valor',
                    prefixIcon: Icon(Icons.monetization_on_outlined),
                    suffix: Text(
                      'reais',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Informe o valor da compra';
                    } else if (double.parse(value) < 50) {
                      return 'Compra miníma de R\$ 50.00';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    // essa acao serve para verificar o que foi digitado e retornar uma resposta
                    setState(() {
                      quantidade = (value.isEmpty)
                          ? 0
                          : double.parse(value) / widget.moeda.preco;
                    });
                  },
                ),
              ),
              Container(
                alignment: Alignment.bottomCenter,
                margin: const EdgeInsets.only(top: 24),
                child: ElevatedButton(
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.amber),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(3))),
                    ),
                    iconColor: WidgetStatePropertyAll(Colors.white),
                    foregroundColor: WidgetStatePropertyAll(Colors.white),
                  ),
                  onPressed: comprar,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.payments),
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          'Comprar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
