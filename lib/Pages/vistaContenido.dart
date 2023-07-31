import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_quill_extensions/embeds/builders.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:flutter_tex/flutter_tex.dart';
import 'package:materiapp/OBJETOS/Contenido.dart';
import 'package:flutter_math_fork/ast.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:materiapp/Pages/AgregarContenido.dart';
import 'package:materiapp/Widgets/FirebaseImageWidget.dart';
import '../OBJETOS/ArchivosSolicitud.dart';
import '../Widgets/ImageEmbed.dart';
import '../Widgets/LatexEmbedBuilder.dart';




class vistaContenido extends StatefulWidget {
  final int ordentema;
  final String nombretema;
  final int ordensubtema;
  final String nombresubtema;

  vistaContenido({required this.ordentema,required this.nombretema,required this.ordensubtema,required this.nombresubtema});

  @override
  _vistaContenidoState createState() => _vistaContenidoState();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fluent UI',
    );
  }
}

class _vistaContenidoState extends State<vistaContenido> {
  quill.QuillController _controller = quill.QuillController.basic();
  final db = FirebaseFirestore.instance;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  List<Contenido> contenidos = []; // Agregar esta línea
  PlatformFile? pickedFile;
  String archivoNombre = "";
  String _archivoExtension = "";
  UploadTask? uploadTask;
  String _imgurl = "";
  List<String> imageUrls = [];
  List<Map<String, dynamic>> contenidoData = [];


  @override
  void initState() {
    super.initState();
    cargardatoscontenido();
  }

  Future<void> cargardatoscontenido() async {
    print("se cargaron los contenidos");
    CollectionReference rerencecontenido = db.collection("MATERIAS").doc("CALCULO 1")
        .collection("TEMAS").doc(
        "${widget.ordentema}. ${widget.nombretema}").collection(
        "SUBTEMAS").doc(
        "${widget.ordentema}.${widget.ordensubtema}. ${widget
            .nombresubtema}").collection("CONTENIDO");
    QuerySnapshot querycontenido = await rerencecontenido.get();
    for (var doc in querycontenido.docs) {
      final data = doc.data() as Map<String, dynamic>;
      contenidoData = (data['contenido'] as List).cast<Map<String, dynamic>>();
      Contenido contenido = Contenido(
        contenidoData,
      );
      contenidos.add(contenido);
      print(contenidos);
    }

    final delta = quill.Delta.fromJson(contenidoData as List);
    _controller.compose(delta,TextSelection.collapsed(offset: 0 ),quill.ChangeSource.LOCAL);

  }



    @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 350,
          child: Column(
            children: [
              quill.QuillToolbar.basic(
                customButtons: [
                  quill.QuillCustomButton(
                      icon: Icons.data_saver_off,
                      onTap: () {
                        _insertarlatex();
                      }
                  ),
                  quill.QuillCustomButton(
                      icon: Icons.photo_camera,
                      onTap: () async {
                        print("subir foto");
                        // Lógica para cargar la imagen aquí
                          selectFile();
                          String imageUrl = await uploadfile();
                          print(imageUrl);
                        }
                  )
                ],
                controller: _controller,
              ),
              Expanded(
                child: Container(
                  child: quill.QuillEditor.basic(
                    controller: _controller,
                    readOnly: false,
                    embedBuilders: [
                      FirebaseImageEmbedBuilder(),
                      VideoEmbedBuilder(),
                      LatexEmbedBuilder(),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                child: Icon(Icons.confirmation_num_sharp),
                onPressed: () {
                  addcontenido();
                  print('oprimido boton');
                },
              ),
            ],
          ),
        ),
        Container(
            width: 350,
            child: Column(
              children: [
                //Toca programar un future
                /*
                StreamBuilder(
                    stream: db.collection("MATERIAS").doc("CALCULO 1")
                        .collection("TEMAS").doc(
                        "${widget.ordentema}. ${widget.nombretema}").collection(
                        "SUBTEMAS").doc(
                        "${widget.ordentema}.${widget.ordensubtema}. ${widget
                            .nombresubtema}").collection("CONTENIDO")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) return Text("cargando");
                      List<Contenido> contenidos = [];
                      for (var doc in snapshot.data!.docs) {
                        final data = doc.data() as Map<String, dynamic>;
                        List<Map<String,
                            dynamic>> contenidoData = (data['contenido'] as List)
                            .cast<Map<String, dynamic>>();
                        Contenido contenido = Contenido(
                          contenidoData,
                        );
                        contenidos.add(contenido);
                      }


                      return Expanded(child: ListView.builder(
                        itemCount: contenidos.length,
                        itemBuilder: (context, index) {
                          final contenido = contenidos[index];
                          final List<Widget> contentWidgets = [];

                          _controller = quill.QuillController(
                            document: quill.Document.fromDelta(quill.Delta
                                .fromJson(contenido.contenido as List)),
                            selection: TextSelection.collapsed(offset: 0),
                          );

                          if(kIsWeb){
                            return Container(
                              height: 500,
                              child:
                              quill.QuillEditor(
                                expands: true,
                                scrollController: _scrollController,
                                focusNode: _focusNode,
                                scrollable: true,
                                padding: EdgeInsets.all(30),
                                controller: _controller,
                                autoFocus: true,
                                readOnly: false, // Para que el contenido sea solo de lectura
                                embedBuilders: [
                                  //ImageEmbedBuilderWeb(),
                                  VideoEmbedBuilder(),
                                  //ResponsiveImageEmbedBuilder(),
                                  LatexEmbedBuilder(),
                                  FirebaseImageEmbedBuilder(),

                                ],

                              )
                            );
                          }

                          print("listsa de widgets $contentWidgets");
                        },

                      ));
                    }
                ),

                 */
              ],
            )
        )
      ],
    );
  }


  void addcontenido() async {
    CollectionReference referencecontenido = db.collection("MATERIAS").doc(
        "CALCULO 1").collection("TEMAS").doc(
        "${widget.ordentema}. ${widget.nombretema}").collection("SUBTEMAS")
        .doc(
        "${widget.ordentema}.${widget.ordensubtema}. ${widget.nombresubtema}")
        .collection("CONTENIDO");

    quill.Delta delta = _controller.document.toDelta();

    List<Map<String, dynamic>> serializedDelta = delta
        .map((op) => op.toJson()) // Convertir cada operación en un mapa JSON
        .toList();

    Map<String, dynamic> contenidoData = {
      "contenido": serializedDelta,
    };
    await referencecontenido.doc("1").set(contenidoData);
  }

  void _insertarlatex() async {
    // Mostrar un cuadro de diálogo para que el usuario ingrese el contenido LaTeX
    String latexContent = await showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController latexController = TextEditingController();
        return AlertDialog(
          title: Text('Insertar fórmula LaTeX'),
          content: TextField(
            controller: latexController,
            decoration: InputDecoration(hintText: 'Ingresa la fórmula LaTeX'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(latexController.text);
              },
              child: Text('Insertar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(_imgurl),
            ),
          ],
        );
      },
    );
// Crear un objeto Delta que representa el contenido LaTeX
    final newLatex = '\$$latexContent\$'; // Encapsular el contenido LaTeX con $ para su renderización.
    final currentPosition = _controller.selection.baseOffset;
    final delta = quill.Delta()..retain(currentPosition)..insert({"latex": latexContent, })..retain(currentPosition);

    // Insertar el contenido LaTeX en la posición actual del cursor
    //_controller.replaceText(currentPosition, 0, newLatex, TextSelection.collapsed(offset: currentPosition + newLatex.length),);
    _controller.compose(delta,TextSelection.collapsed(offset: currentPosition ),quill.ChangeSource.LOCAL);

    // Agregar el contenido LaTeX como tipo "latex" a la lista contenidos
    setState(() {
      print("contenido $contenidos");
    });


  }

  Future selectFile() async{
    if(kIsWeb){
      final result = await FilePicker.platform.pickFiles(type: FileType.any, allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {
        final fileBytes = result.files.first.bytes;
        final fileName = result.files.first.name;
        final fileextension = result.files.first.extension;
        setState(() {
          pickedFile = result.files.first;
          archivoNombre = fileName;
          _archivoExtension = fileextension!;
          print(fileName);
          print(fileextension);
        });
        print("extension archivo");
        print(_archivoExtension);
        print("Nombre del archivo");

        uploadfile();
      }}else{

      final result = await FilePicker.platform.pickFiles(allowMultiple: false);

      if (result != null && result.files.isNotEmpty) {

        final fileName = result.files.first.name;
        final fileextension = result.files.first.extension;

        setState(() {
          pickedFile = result.files.first;
          archivoNombre = fileName;
          print(fileName);
          _archivoExtension = fileextension!;
          print(fileextension);
          print(pickedFile);
        });
      }
    }
  }

  Future<String> uploadfile() async{
    if(kIsWeb){
      TaskSnapshot taskSnapshot = await FirebaseStorage.instance
          .ref('ARCHIVOS/${pickedFile?.name}')
          .putData(pickedFile!.bytes!);

      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      String imageFile = downloadUrl;

      print('Download Link: $downloadUrl');
      setState(() {
        _imgurl=downloadUrl;
      });
      CollectionReference newarchivos = db.collection("SOLICITUDES");
      ArchivoSolicitud newarhicvosolicitud = ArchivoSolicitud(archivoNombre,downloadUrl,_archivoExtension);
      await newarchivos.doc("ss").collection("ARCHIVOS").add(newarhicvosolicitud.toMap());
      print(newarhicvosolicitud);
      _insertarImagenEnQuill(_imgurl);

      return _imgurl;


    }else{
      final file = File(pickedFile!.path!);
      final path = 'SOLICITUDES/"sss/${pickedFile?.name}';
      final ref = FirebaseStorage.instance.ref().child(path);
      setState(() {
        uploadTask = ref.putFile(file);
      });
      final snapshot = await uploadTask!.whenComplete(() {});
      final urDownload = await snapshot.ref.getDownloadURL();
      print('Download Link: $urDownload');
      setState(() {
        uploadTask = null;
      });
      CollectionReference newarchivos = db.collection("SOLICITUDES");
      ArchivoSolicitud newarhicvosolicitud = ArchivoSolicitud(archivoNombre,urDownload,  _archivoExtension);
      await newarchivos.doc("sss").collection("ARCHIVOS").add(newarhicvosolicitud.toMap());

      return _imgurl;
    }
  }

  void _insertarImagenEnQuill(String imageUrl) {
    // Inserta la imagen en el editor usando la URL de descarga
    final currentPosition = _controller.selection.extentOffset  ;
    final delta = quill.Delta()..retain(currentPosition)..insert({"image": imageUrl, });
    print("pos puntero = $currentPosition");

    _controller.compose(delta,TextSelection.collapsed(offset: currentPosition ),quill.ChangeSource.LOCAL);

  }


  }



