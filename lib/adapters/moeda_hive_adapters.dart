import 'package:criptos/models/moedas.dart';
import 'package:hive/hive.dart';

class MoedaHiveAdapter extends TypeAdapter<Moedas>{
  
  @override
  final typeId = 0;
  
  @override
  Moedas read (BinaryReader reader){
    return Moedas(
      icone: reader.readString(),
      nome: reader.readString(),
      preco: reader.readDouble(),
      sigla: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Moedas obj){
    writer.writeString(obj.icone);
    writer.writeString(obj.nome);
    writer.writeDouble(obj.preco);
    writer.writeString(obj.sigla);
  }
  
}