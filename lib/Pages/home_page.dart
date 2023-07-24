import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../OBJETOS/Materias.dart';

class HomePage extends StatefulWidget {
  final String texto;
  final String idcotizacion;
  final String materia;
  final String estado;

  HomePage({required this.texto,required this.idcotizacion,required this.materia,required this.estado});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _registromateria = "";
  final db = FirebaseFirestore.instance;
  int _currentPage = 0;


  @override
  Widget build(BuildContext context) {
    final currentwidth = MediaQuery.of(context).size.width;
    final currentheight = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.materia} #${widget.idcotizacion.toString()} COTIZACIONES'),
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 90.0),
                child: Column(children: [
                  Text('MANEJO DE BASE DE DATOS'),

                  Text('Registrar materia'),
                  TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      labelText: 'AGREGAR MATERIA',
                      icon: const Icon(Icons.person),
                    ),
                    obscureText: false,
                    onChanged: (value){
                      setState(() {
                        _registromateria = value;
                      });
                    },
                  ),
                  ElevatedButton(onPressed: (){
                    addmateria();
                    print("oprimido boton y subido m ateria");
                  }, child: Text("subir materia")),
                  StreamBuilder(
                      stream: db.collection("MATERIAS").snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData) return CircularProgressIndicator();
                        List<Materia> materias = [];
                        for(var doc in snapshot.data!.docs){
                          final data = doc.data() as Map<String,dynamic>;
                          Materia materia = Materia(
                            data['nombremateria'],
                            data['actualizar curso'],
                            data['fecha actualizacion'].toDate(),
                          );
                          materias.add(materia);
                        }
                        return Center(
                          child: Container(
                            height: 450,
                            width: 450,
                            child: ListView.builder(
                                itemCount: snapshot.data?.size,
                                itemBuilder: (context,index){
                                  Materia materia = materias[index];
                                  return SingleChildScrollView(
                                    child:  Column(
                                      children: [
                                        Text(materia.nombremateria),
                                      ],
                                    ),
                                  );
                                }),
                          ),
                        );
                      }
                  ),

                ],
                ),
              ),
            ),
          ],
        )
    );
  }

  void addmateria()async{
    CollectionReference materiareference = db.collection("MATERIAS");
    Materia newmateria = Materia(_registromateria, "NO", DateTime.now());
    await materiareference.doc(_registromateria).set(newmateria.toMap());
    print(newmateria);
  }
}