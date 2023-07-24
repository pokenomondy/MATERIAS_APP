import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:materiapp/OBJETOS/Subtemas.dart';
import 'package:materiapp/OBJETOS/Temas.dart';
import '../subPages/PruebaNavegacion.dart';
import '../utils/app_navigator.dart';
import '../OBJETOS/Materias.dart';
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
                      setState(() => selectedMateria = text);
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
              Text("2 column"),
              Container(
                width: 350,
                child: Column(children: [
                  Text('2 columna'),
                  Text('Agregar temas , aqui viene'),
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
                      cargarnumerodeTemasMaterias();
                      print('oprimido boton');
                    },
                  ),
                  FilledButton(
                    child: const Text('A otra actividad prueba'),
                    onPressed: (){
                      aotraactividad();
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
                Text("3 column"),
                Text('segundo texto si si rve'),

                StreamBuilder(
                    stream: db.collection("MATERIAS").doc(selectedMateria).collection("TEMAS").snapshots(),
                    builder: (context, snapshot){
                      if(!snapshot.hasData) return Text('Cargando');
                      temas.clear();
                      for(var doc in snapshot.data!.docs){
                        final data = doc.data() as Map<String,dynamic>;
                        Temas tema = Temas(
                            data['nombre Tema'],
                            data['Orden tema']
                        );
                        temas.add(tema);
                        print(tema);
                      }
                      return Center(
                        child: Container(
                          height: 450,
                          color: Colors.red,
                          width: 450,
                          child: ListView.builder(
                              itemCount: snapshot.data?.size,
                              itemBuilder: (context,index){
                                Temas tema = temas[index];

                                return  Column(
                                  children: [
                                    ListTile.selectable(
                                      title: Text("${tema.ordentema}. ${tema.nombreTema}"),
                                      onPressed: (){
                                        print("oprimito ${tema.nombreTema}");
                                      },
                                      trailing: Column(
                                        children: [
                                          Text(_numdeSubtemas.toString()),
                                        ],
                                      ),


                                    ),
                                    TextBox(
                                      placeholder: "Nombre",
                                      onChanged: (value){
                                        setState(() {
                                          _addsubtema = value;
                                          print(_addsubtema);
                                        });
                                      },
                                    ),
                                    FilledButton(
                                      child: const Text('Agregar SubTema'),
                                      onPressed: () async {
                                        cargarnumerodeSubtemasMaterias(tema.nombreTema,tema.ordentema);
                                        print('oprimido boton');
                                      },
                                    ),
                                    StreamBuilder(
                                        stream: db.collection("MATERIAS").doc(selectedMateria).collection("TEMAS").doc("${tema.ordentema}. ${tema.nombreTema}").collection("SUBTEMAS").snapshots(),
                                        builder: (context,snapshot){
                                          if(!snapshot.hasData) return Text('Cargando');
                                          List<SubTemas> subtemas = [];
                                          subtemas.clear();
                                          for(var doc in snapshot.data!.docs){
                                            final data = doc.data() as Map<String,dynamic>;
                                            SubTemas subtema = SubTemas(
                                              data['nombreSubTema'],
                                              data['ordenSubtema'],
                                            );
                                            subtemas.add(subtema);
                                          }
                                          int? numsubtemas = snapshot.data?.size;
                                          print(numsubtemas);

                                          if(numsubtemas == 0){
                                            return Text('No hay subtemas');
                                          }else{
                                            return Container(
                                              height: 150,
                                              child: ListView.builder(
                                                  itemCount: snapshot.data?.size,
                                                  itemBuilder: (context,index){
                                                    SubTemas subtema = subtemas[index];

                                                    return ListTile(
                                                      title: Text("${tema.ordentema}.${subtema.ordenSubtema}. ${subtema.nombreSubTema}"),
                                                      trailing:PruebaNavegacion(ordentema: tema.ordentema, nombretema: tema.nombreTema, ordensubtema: subtema.ordenSubtema, nombresubtema: subtema.nombreSubTema),

                                                    );
                                                  }),
                                            );
                                          }
                                        }
                                        ),
                                  ],
                                );


                              }),


                        ),
                      );
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
    Temas newtema = Temas(_addtema, _numordentema);
    String anidado = "$_numordentema. $_addtema";
    await reference.doc(anidado).set(newtema.toMap());
  }

  void addsubtemamateria(String nombreTema, int ordentema) async{
    print("a subir la submateroa");
    CollectionReference reference = db.collection("MATERIAS").doc(selectedMateria).collection("TEMAS").doc("$ordentema. $nombreTema").collection("SUBTEMAS");
    SubTemas newsubtema = SubTemas(_addsubtema, _numdeSubtemas);
    String anidado = "1.$_numdeSubtemas. $_addsubtema";
    await reference.doc(anidado).set(newsubtema.toMap());
  }

  void aotraactividad() {
    print("navegar");
    AppNavigator.navigateTo('AgregarContenido'); // Navegar a la ruta 'agregar_temas'
  }
}




