
import 'package:materiapp/OBJETOS/Contenido.dart';

class SubTemasRegistro {
  String nombreSubTema = "";
  int ordenSubtema = 1;


  SubTemasRegistro(this.nombreSubTema,this.ordenSubtema);

  Map<String, dynamic> toMap(){
    return{
      "nombreSubTema":nombreSubTema,
      "ordenSubtema":ordenSubtema,
    };
  }

}