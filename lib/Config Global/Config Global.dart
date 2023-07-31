import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../OBJETOS/Contenido.dart';
import '../OBJETOS/Subtemas.dart';
import '../OBJETOS/Temas.dart';

List<Temas> temasList = [];

class Config {
  static const Color primary_color = Color(0xFF0528F0);
  static const Color second_color = Color(0xFF0540F0);
  static const Color third_color = Color(0xFF6387F2);
  static const Color contrast_color = Color(0xFFF00505);
  static const Color white_color = Color(0xFFF2F2F2);
  static const Color gray_color = Color(0xFF3C3C3B);

  Future obtenerTemasDesdeFirebase(String materiaseleccionada) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool datosDescargados = prefs.getBool('datos_descargados_listatemas') ?? false;
    if (!datosDescargados) {
      temasList.clear();
      // print("Los datos apenas se van a descargar, priemra vez");
      CollectionReference referenceTemas = FirebaseFirestore.instance
          .collection("MATERIAS").doc(materiaseleccionada).collection("TEMAS");
      QuerySnapshot queryTemas = await referenceTemas.get();

      for (var temaDoc in queryTemas.docs) {
        String nombreTema = temaDoc['nombre Tema'];
        int ordenTema = temaDoc['Orden tema'];
         print("$ordenTema $nombreTema");

        //Ahora metemos subtemas para crear la lista y guardar
        QuerySnapshot subtemasDocs = await temaDoc.reference.collection(
            'SUBTEMAS').get();
        List<SubTemas> subtemasList = [];
        for (var subtemaDoc in subtemasDocs.docs) {
          String nombreSubTema = subtemaDoc['nombreSubTema']; // Suponiendo que 'nombreSubTema' es el campo que contiene el nombre del subtema
          int ordenSubtema = subtemaDoc['ordenSubtema'];
           print("$ordenTema $ordenSubtema $nombreSubTema");

          //Ahora cargamos el contenido
          QuerySnapshot contenidoDocs = await subtemaDoc.reference.collection(
              "CONTENIDO").get();

          List<Contenido> contenidos = [];
          List<Map<String, dynamic>> contenidoData = [];
          for (var contenidoDoc in contenidoDocs.docs) {
            final data = contenidoDoc.data() as Map<String, dynamic>;
            contenidoData =
                (data['contenido'] as List).cast<Map<String, dynamic>>();
            Contenido contenido = Contenido(contenidoData,);
            contenidos.add(contenido);
             print("contenido = $contenidoData");
          }
          //guaramos subtemas
          SubTemas subtema = SubTemas(nombreSubTema, ordenSubtema, contenidos);
          subtemasList.add(subtema);
        }

        Temas tema = Temas(nombreTema, ordenTema, subtemasList);
        temasList.add(tema);
        // print("temalist $temasList");
      }
      guardardatos(materiaseleccionada);
      return temasList;
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String temasJson = prefs.getString('temas_list_$materiaseleccionada') ?? '';
      List<dynamic> temasData = jsonDecode(temasJson);
      List temasList = temasData.map((temaData) => Temas.fromJson(temaData)).toList();
      return temasList;
    }
  }

  Future guardardatos(String materiaseleccionada) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String temasJson = jsonEncode(temasList); //convertios a Json para guardar
    await prefs.setString('temas_list_$materiaseleccionada', temasJson); // Guardamos en shared preferecnes
    await prefs.setBool('datos_descargados_listatemas', true);
  }

  Future<void> eliminarSharedPreferences(String materiaseleccionada) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('temas_list_$materiaseleccionada');
    await prefs.remove('datos_descargados_listatemas');
  }
}