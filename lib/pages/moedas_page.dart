import 'package:criptos/models/moedas.dart';
import 'package:criptos/pages/moedas_detalhes_page.dart';
import 'package:criptos/repositorios/favoritas_repositorio.dart';
import 'package:criptos/repositorios/moedas_repositorio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MoedasPage extends StatefulWidget {
  const MoedasPage({super.key});
  @override
  State<MoedasPage> createState() => _MoedasPageState();
}

class _MoedasPageState extends State<MoedasPage> {
  List<Moedas> selecionadas = [];
  NumberFormat real = NumberFormat.currency(locale: 'pt_BR', name: 'R\$');
  // usa a barra invertidar para o $ ser conhecido como texto.
  final tabela = MoedaRepositorio.tabela;
  late Favoritas favoritas;

  // isso é uma funcao
  AppBar appBarDinamica() {
    if (selecionadas.isEmpty) {
      return AppBar(
        centerTitle: true,
        title: const Text('Cripto Moedas'),
        backgroundColor: Colors.amber,
      );
    } else {
      return AppBar(
        leading: IconButton(
          onPressed: () {
            setState(() {
              selecionadas = [];
            });
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text('${selecionadas.length} selecionadas'),
        backgroundColor: Colors.blueGrey[50],
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.black87),
        titleTextStyle: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      );
    }
  }

  void mostrarDetalhes(Moedas moeda) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MoedaDetalhesPage(moeda: moeda),
      ),
    );
  }

  void limparSelecionadas() {
    setState(() {
      selecionadas = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    //favoritas = Provider.of<Favoritas>(context);
    favoritas = context.watch<Favoritas>();
    return Scaffold(
      appBar: appBarDinamica(),
      body: ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          final moeda = tabela[index];
          return ListTile(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            leading: (selecionadas.contains(moeda))
                ? const CircleAvatar(
                    child: Icon(Icons.check),
                  )
                : SizedBox(
                    width: 40,
                    child: Image.asset(moeda.icone),
                  ),
            title: Row(
              children: [
                Text(
                  moeda.nome,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (favoritas.lista.contains(moeda))
                  const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(Icons.favorite, color: Colors.amber, size: 20),
                  )
              ],
            ),
            trailing: Text(
              real.format(moeda.preco),
            ),
            selected: selecionadas.contains(moeda),
            selectedTileColor: Colors.blueAccent,
            onLongPress: () {
              setState(
                () {
                  selecionadas.contains(moeda)
                      ? selecionadas.remove(moeda)
                      : selecionadas.add(moeda);
                },
              );
            },
            onTap: () => mostrarDetalhes(moeda),
          );
        },
        padding: const EdgeInsets.all(16),
        separatorBuilder: (_, __) => const Divider(),
        itemCount: tabela.length,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: selecionadas.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                favoritas.saveAll(selecionadas);
                limparSelecionadas();
              },
              icon: const Icon(Icons.star),
              label: const Text(
                'Favoritar',
                style: TextStyle(
                  letterSpacing: 0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: Colors.amber,
            )
          : null,
    );
  }
}
