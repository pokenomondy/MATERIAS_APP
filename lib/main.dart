import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:materiapp/DASH%20ADMON/admin_dash.dart';
import 'package:materiapp/Pages/AgregarContenido.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      //name: "asdsa",
      options: const FirebaseOptions(
          apiKey: "AIzaSyCumzB24PT5pzfAGfgbmK_lKS9arTgSI-w",
          authDomain: "materias-app-2ab7f.firebaseapp.com",
          projectId: "materias-app-2ab7f",
          storageBucket: "materias-app-2ab7f.appspot.com",
          messagingSenderId: "1086255448541",
          appId: "1:1086255448541:web:690959dec424eb9e84f634"));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
      routes: {
        'agregar_contenido': (context) => AgregarContenido(), // Ruta para 'AgregarContenido'
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
           ElevatedButton(onPressed: (){
             Navigator.push(
               context,
               MaterialPageRoute(builder: (context) => adminDash()),
             );
           }, child: Text("DASH AMDIN")),
          ],
        ),
      ),
    );
  }
}
