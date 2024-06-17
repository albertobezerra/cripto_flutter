import 'package:criptos/repositorios/favoritas.dart';
import 'package:criptos/widget/moeda_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritasPage extends StatefulWidget {
  const FavoritasPage({super.key});

  @override
  State<FavoritasPage> createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: const Text('Minhas moedas favoritas'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(16),
        child: Consumer<Favoritas>(builder: (context, favoritas, child) {
          return favoritas.lista.isEmpty
              ? const ListTile(
                  leading: Icon(Icons.star),
                  title: Text('Nenhuma moeda favorita'),
                )
              : ListView.builder(
                  itemCount: favoritas.lista.length,
                  itemBuilder: (_, index) {
                    return MoedaCard(moeda: favoritas.lista[index]);
                  },
                );
        }),
      ),
    );
  }
}
