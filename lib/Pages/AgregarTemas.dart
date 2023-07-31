import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:materiapp/Config%20Global/Config%20Global.dart';
import 'package:materiapp/OBJETOS/Subtemas.dart';
import 'package:materiapp/OBJETOS/Temas.dart';
import '../OBJETOS/ObjetosRegistro/SubtemasRegistro.dart';
import '../OBJETOS/ObjetosRegistro/TemasRegistro.dart';
import '../subPages/PruebaNavegacion.dart';
import '../utils/app_navigator.dart';
import 'AgregarContenido.dart';


class AgregarTemas extends StatefulWidget {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  static void navigateTo(String routeName) {
    navigatorKey.currentState?.pushNamed(routeName);
  }

  @override
  _AgregarTemasState createState() => _AgregarTemasState();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FluentApp(
        title: 'Fluent UI',
        home: AgregarTemas(),
        navigatorKey: navigatorKey,
      routes: {
        'agregar_contenido': (context) => AgregarContenido(), // Ruta para 'AgregarContenido'
      },

    );
  }
}

class _AgregarTemasState extends State<AgregarTemas> {
  String? selectedMateria;
  String? selectedTema;
  List<String> materias = ['CALCULO 1'];
  List<String> temasmateria = [];
  String _addtema = "";
  int _numordentema = 1;
  final db = FirebaseFirestore.instance;
  List<Temas> temas = [];
  bool _cargarnombrematerias = false;
  String _addsubtema = "";
  int _numdeSubtemas = 1;
  Config config = Config();

  @override
  void initState() {
    super.initState();
  }

  Future<void> cargarnumerodeTemasMaterias()async{
    CollectionReference referencetemas = db.collection("MATERIAS").doc(selectedMateria).collection("TEMAS");
    QuerySnapshot querytemas = await referencetemas.get();

    int numDocumentos = querytemas.size;
    _numordentema =  numDocumentos;
    print("numero de documentos $numDocumentos");

    setState(() {
      _numordentema = numDocumentos+1;
      print("numero nuevo de tema es igual $_numdeSubtemas");
    });
    addtemamateria();
  }

  Future<void> cargarnumerodeSubtemasMaterias(String nombreTema, int ordentema) async{
    CollectionReference referencesubtemas = db.collection("MATERIAS").doc(selectedMateria).collection("TEMAS").doc("${ordentema}. ${nombreTema}").collection("SUBTEMAS");
    QuerySnapshot qerusybtemas = await referencesubtemas.get();

    int numDocumentos = qerusybtemas.size;
    _numdeSubtemas =  numDocumentos;
    print("numero de documentos $numDocumentos");

    setState(() {
      _numdeSubtemas = numDocumentos+1;
    print("numero nuevo de tema es igual $_numordentema");
    });

    addsubtemamateria(nombreTema,ordentema);
  }


  @override
  Widget build(BuildContext context) {
    final currentwidth = MediaQuery.of(context).size.width;
    final currentheight = MediaQuery.of(context).size.height;
    return NavigationView(
      key: AgregarTemas.navigatorKey,
      content: Row(
        children: [
          Container(
            color: Colors.red,
            child: Column(
              children: [
                Text("1 column"),
                Column(children: [
                  ComboBox<String>(
                    value: selectedMateria,
                    items: materias.map<ComboBoxItem<String>>((e) {
                      return ComboBoxItem<String>(
                        child: Text(e),
                        value: e,
                      );
                    }).toList(),
                    onChanged: (text) {
                      setState(() =>
                      selectedMateria = text
                      );
                      print("materia seleccionado $selectedMateria");
                    },
                    placeholder: const Text('Select a cat breed'),
                  ),
                ],),

              ],
            ),
          ),
          Container(
            width: 300,
            color: Colors.blue,
            child: Column(children: [
              Container(
                width: 350,
                child: Column(children: [
                  Text('Agregar temas'),
                  TextBox(
                    placeholder: "Nombre",
                    onChanged: (value){
                      setState(() {
                        _addtema = value;
                        print(_addtema);
                      });
                    },
                  ),
                  FilledButton(
                    child: const Text('Agregar Tema'),
                    onPressed: (){
                      config.eliminarSharedPreferences(selectedMateria!);
                      cargarnumerodeTemasMaterias();
                      print('oprimido boton');
                    },
                  ),




                ],),
              ),

            ],
            ),
          ),
          Container(
            color: Colors.green,
            width: 300,
            child: Column(
              children: [

                if(selectedMateria!=null)
                FutureBuilder(
                    future: config.obtenerTemasDesdeFirebase(selectedMateria!),
                    builder: (context,snapshot){
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        // Mientras se espera, mostrar un mensaje de carga
                        return Center(
                          child: Text("cargando"), // O cualquier otro widget de carga
                        );
                      } else if (snapshot.hasError) {
                        // Si ocurre un error en el Future, mostrar un mensaje de error
                        return Center(
                          child: Text("Error al cargar los datos"),
                        );
                      } else {
                        List<Temas> temaslist = snapshot.data;
                        return CuadroTema(temaslist);
                      }
                    }
                    ),

              ],
            ),
          ),
        ],
      ),
    );

  }

  void addtemamateria() async{
    print("a subir la materia");
    CollectionReference reference = db.collection("MATERIAS").doc(selectedMateria).collection("TEMAS");
    TemasRegistro newtema = TemasRegistro(_addtema, _numordentema);
    String anidado = "$_numordentema. $_addtema";
    await reference.doc(anidado).set(newtema.toMap());
  }

  void addsubtemamateria(String nombreTema, int ordentema) async{
    print("a subir la submateroa");
    CollectionReference reference = db.collection("MATERIAS").doc(selectedMateria).collection("TEMAS").doc("$ordentema. $nombreTema").collection("SUBTEMAS");
    SubTemasRegistro newsubtema = SubTemasRegistro(_addsubtema, _numdeSubtemas);
    String anidado = "1.$_numdeSubtemas. $_addsubtema";
    await reference.doc(anidado).set(newsubtema.toMap());
  }

  void aotraactividad() {
    print("navegar");
    AppNavigator.navigateTo('AgregarContenido'); // Navegar a la ruta 'agregar_temas'
  }
}

class CuadroTema extends StatefulWidget {
  final List<Temas> temaslist;


  CuadroTema(this.temaslist);

  @override
  _CuadroTemaState createState() => _CuadroTemaState();
}

class _CuadroTemaState extends State<CuadroTema> {
  int? _expandedIndex; // Rastrea el índice del tema expandido


  @override
  Widget build(BuildContext context) {
    final double currentwidth = MediaQuery.of(context).size.width;
    final double currentheight = MediaQuery.of(context).size.height;

    return Container(
      height: currentheight-100,
      child: ListView.builder(
          itemCount: widget.temaslist.length,
          itemBuilder: (context,index){
            Temas tema = widget.temaslist[index];

              return Column(
                children: [
                  ListTile(
                    title: Text("${tema.ordentema}. ${tema.nombreTema}"),),
                  TextBox(
                    placeholder: "Nombre",
                    onChanged: (value){
                      setState(() {
                      });
                    },
                  ),
                  FilledButton(
                    child: const Text('Agregar SubTema'),
                    onPressed: () async {
                    },
                  ),
                  Container(
                    height: 100,
                    child: ListView.builder(
                        itemCount: tema.subtemas.length,
                        itemBuilder: (context,subindex){
                          SubTemas subtema = tema.subtemas[subindex];

                          return Container(
                            height: 70,
                            child: ListTile(
                              title: Text("${tema.ordentema}.${subtema.ordenSubtema}. ${subtema.nombreSubTema}"),
                              trailing:PruebaNavegacion(ordentema: tema.ordentema, nombretema: tema.nombreTema, ordensubtema: subtema.ordenSubtema, nombresubtema: subtema.nombreSubTema),
                            ),
                          );
                        }
                        ),
                  ),
                ],
              );

          }
          ),
    );

  }



}



