import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:materiapp/DASH%20ADMON/admin_dash.dart';
import 'package:materiapp/Pages/AgregarTemas.dart';
import 'package:materiapp/vistaContenido.dart';

class PruebaNavegacion extends StatefulWidget {
  final int ordentema;
  final String nombretema;
  final int ordensubtema;
  final String nombresubtema;

  PruebaNavegacion({required this.ordentema,required this.nombretema,required this.ordensubtema,required this.nombresubtema});

  @override
  _PruebaNavegacionState createState() => _PruebaNavegacionState();
}

class _PruebaNavegacionState extends State<PruebaNavegacion> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(onPressed: () {
      aotrapantalla();
      print('oprimiendo boton');
    },
    child: Text("A"),

    );
  }

  void aotrapantalla() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  vistaContenido(ordentema: widget.ordentema,ordensubtema: widget.ordensubtema,nombresubtema: widget.nombresubtema,nombretema: widget.nombretema,)
      ),
    );
    print('oprimido boton parece');
  }


}