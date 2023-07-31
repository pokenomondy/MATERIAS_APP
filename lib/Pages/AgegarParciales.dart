import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../OBJETOS/Materias.dart';

class AgregarParciales extends StatefulWidget {


  @override
  _AgregarParcialesState createState() => _AgregarParcialesState();
}

class _AgregarParcialesState extends State<AgregarParciales> {
  String _fraseparcial = "";
  String _universidad = ""; //Esto debe ser una lista extraida de dufy asesorias
  String _materia = "";
  String _tema = "";
  List<String> subtemas = [];


  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: Row(
        children: [
          Container(
            width: 150,
            child: Column(
              children: [
              ],
            ),
          ),
          Container(
            width: 300,
            child:Column(
              children: [
                Text("Agregar parcial"),
                TextBox(
                  placeholder: "frase parcial",
                  onChanged: (value){
                    setState(() {
                      _fraseparcial = value;
                    });
                  },
                ),
                TextBox(
                  placeholder: "Universidad",
                  onChanged: (value){
                    setState(() {
                      _universidad = value;
                    });
                  },
                ),
                TextBox(
                  placeholder: "Materia",
                  onChanged: (value){
                    setState(() {
                      _materia = value;
                    });
                  },
                ),
                TextBox(
                  placeholder: "Tema",
                  onChanged: (value){
                    setState(() {
                      _tema = value;
                    });
                  },
                ),
                TextBox(
                  placeholder: "Subtemas en forma de lista",
                  onChanged: (value){
                    setState(() {
                    });
                  },
                ),

              ],
            ),
          ),
          Container(
            width: 300,
            child: Text("a"),
          ),
        ],
      ),

    );
  }


}