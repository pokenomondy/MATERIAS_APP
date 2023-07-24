import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:intl/intl.dart';
import 'package:materiapp/Pages/AgregarTemas.dart';

import '../OBJETOS/Materias.dart';

class ContentPage extends StatefulWidget {
  final String texto;
  final String idcotizacion;
  final String materia;
  final String estado;


  ContentPage({required this.texto,required this.idcotizacion,required this.materia,required this.estado});

  @override
  _ContentPageState createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  String? selectedCat;
  List<String> cats = [
    'Abyssinian',
    'Aegean',
    'American Bobtail',
    'American Curl',
  ];
  String _registromateria = "";
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: Column(
        children: [
          FilledButton(
            child: const Text('Filled Button'),
            onPressed: (){
              print('oprimido boton');
            },
          ),
          TextBox(),
          InfoLabel(
            label: 'Enter your name:',
            child: const TextBox(
              placeholder: 'Name',
              expands: false,
            ),
          ),
          //Toca aprender a hacer autosuggestedbotx
          StreamBuilder(
              stream: db.collection("MATERIAS").snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData) return Text('Hola');
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
                          return ListTile.selectable(
                            title: Text(materia.nombremateria),
                            onPressed: (){
                              print("oprimito ${materia.nombremateria}");
                            },
                          );
                        }),


                  ),
                );
              }
          ),


        ],
      ),

    );
  }


}