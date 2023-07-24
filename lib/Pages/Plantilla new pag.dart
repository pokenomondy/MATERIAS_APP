import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../OBJETOS/Materias.dart';

class ExamplePage extends StatefulWidget {
  final String texto;
  final String idcotizacion;
  final String materia;
  final String estado;

  ExamplePage({required this.texto,required this.idcotizacion,required this.materia,required this.estado});

  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  @override
  Widget build(BuildContext context) {
    return NavigationView(

    );
  }


}