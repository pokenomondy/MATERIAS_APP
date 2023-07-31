import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:materiapp/OBJETOS/Materias.dart';
import 'package:materiapp/Pages/AgegarParciales.dart';
import 'package:materiapp/Pages/AgregarTemas.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'AgregarContenido.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(adminDash());
}

class adminDash extends StatelessWidget{
  const adminDash({super.key});

  @override
  Widget build(BuildContext context) {
    return FluentApp(
      title: 'Fluent UI',
      home: const adminDashhome(),
      routes: {
        'agregar_contenido': (context) => AgregarContenido(), // Ruta para 'AgregarContenido'
      },
    );
  }
}

class adminDashhome extends StatefulWidget {
  const adminDashhome({Key? key}) : super(key: key);

  @override
  State<adminDashhome> createState() => _adminDashhomeState();
}

class _adminDashhomeState extends State<adminDashhome> {
  String _registromateria = "";
  final db = FirebaseFirestore.instance;
  int _currentPage = 0;


  @override
  Widget build(BuildContext context) {
    final currentwidth = MediaQuery.of(context).size.width;
    final currentheight = MediaQuery.of(context).size.height;
    final openmaxpanel = 50;
    final openminpanel = 150;
    return NavigationView(
      appBar: NavigationAppBar(
        title: Container(
          margin:  const EdgeInsets.only(left: 20),
          child:  const Text('DASH ADMIN',
            style: TextStyle(fontSize: 32),),
        ),
        automaticallyImplyLeading: false,
      ),
      pane: NavigationPane(
        size: NavigationPaneSize(
          openMaxWidth: 150.00,
          openMinWidth: 50.00,
        ),
        items: <NavigationPaneItem>[
          PaneItem(icon: const Icon(FluentIcons.home),
              title: const Text('Agregar temasxx  '), body: AgregarTemas()),
          PaneItem(icon: const Icon(FluentIcons.home),
              title: const Text('Agegar parciales'), body: AgregarParciales()),
        ],
        selected: _currentPage,
        onChanged: (index) => setState(() {
          _currentPage = index;
        }),
      ),

    );
  }

  void addmateria()async{
    CollectionReference materiareference = db.collection("MATERIAS");
    Materia newmateria = Materia(_registromateria, "NO", DateTime.now());
    await materiareference.doc(_registromateria).set(newmateria.toMap());
    print(newmateria);
  }
}
