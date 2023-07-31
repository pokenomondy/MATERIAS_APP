
import 'package:materiapp/OBJETOS/Subtemas.dart';

class TemasRegistro {
  String nombreTema = "";
  int ordentema = 1;


  TemasRegistro(this.nombreTema,this.ordentema);


  Map<String, dynamic> toMap(){
    return{
      "nombre Tema":nombreTema,
      "Orden tema":ordentema,
    };
  }
}

