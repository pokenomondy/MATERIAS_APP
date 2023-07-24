class Materia {
  String nombremateria = "";
  String actualizarcurso = "";
  DateTime fechaultactualizacion = DateTime.now();

  Materia(this.nombremateria,this.actualizarcurso,this.fechaultactualizacion);

  Map<String, dynamic> toMap(){
    return{
      "nombremateria":nombremateria,
      "actualizar curso":actualizarcurso,
      "fecha actualizacion":fechaultactualizacion,
    };
  }

}