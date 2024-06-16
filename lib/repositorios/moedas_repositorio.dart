import '../models/moedas.dart';

class MoedaRepositorio {
  static List<Moedas> tabela = [
    Moedas(
      icone: 'assets/imagens/bitcoin.png',
      nome: 'Bitcoin',
      sigla: 'BTC',
      preco: 164603.00,
    ),
    Moedas(
      icone: 'assets/imagens/etherium.png',
      nome: 'Etherium',
      sigla: 'ETH',
      preco: 9716.00,
    ),
    Moedas(
      icone: 'assets/imagens/xrp.png',
      nome: 'XRP',
      sigla: 'XRP',
      preco: 3.34,
    ),
    Moedas(
      icone: 'assets/imagens/cardano.png',
      nome: 'Cardano',
      sigla: 'ADA',
      preco: 6.32,
    ),
    Moedas(
      icone: 'assets/imagens/lite.png',
      nome: 'Litecoin',
      sigla: 'LTC',
      preco: 669.93,
    ),
    Moedas(
      icone: 'assets/imagens/usdcoin.jpg',
      nome: 'USD Coin',
      sigla: 'USD',
      preco: 5.02,
    ),
  ];
}
