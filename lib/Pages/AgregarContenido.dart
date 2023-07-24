import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:intl/intl.dart';
import 'package:materiapp/Pages/AgregarTemas.dart';
import 'package:materiapp/subPages/PruebaNavegacion.dart';

import '../OBJETOS/Materias.dart';

class AgregarContenido extends StatefulWidget {

  @override
  _AgregarContenidoState createState() => _AgregarContenidoState();
}

class _AgregarContenidoState extends State<AgregarContenido> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: Column(
        children: [
          Text('hola'),
          Column(
            children: [
              FilledButton(
                child: const Text('IR A OTRA PANTALLA'),
                onPressed: (){
                  print('oprimido boton');
                },
              ),
              Column(children: [
                Math.tex(r'x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}', mathStyle: MathStyle.display),
              ],)
              ],
          ),
        ],
      ),
    );
  }


    // Utilizar el Navigator para agregar la ruta 'agregar_temas'


}