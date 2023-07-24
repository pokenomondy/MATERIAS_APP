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
import 'OBJETOS/ArchivosSolicitud.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart' as quill;

import 'Widgets/TimeStampEmbedBuilderWidget.dart';




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
                          if (imageUrl != null) {
                            // Inserta la imagen en el editor Quill
                            _insertarImagenEnQuill(imageUrl);
                          }
                        }
                  )
                ],
                controller: _controller,
              ),
              Expanded(
                child: Container(
                  child: quill.QuillEditor.basic(
                    controller: _controller,
                    readOnly: false, // true for view only mode
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
                Math.tex(r'x = \frac{-b \pm \sqrt{b^2 - 4ac}}{2a}',
                    mathStyle: MathStyle.display),
                Text("asdas"),
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


                      return Container(
                        height: 500,
                        child: ListView.builder(
                          itemCount: contenidos.length,
                          itemBuilder: (context, index) {
                            final contenido = contenidos[index];
                            final List<Widget> contentWidgets = [];

                            final quillController = quill.QuillController(
                              document: quill.Document.fromDelta(quill.Delta
                                  .fromJson(contenido.contenido as List)),
                              selection: TextSelection.collapsed(offset: 0),
                            );

                            for (final op in contenido.contenido) {
                              final attributes = op["attributes"];
                              final insert = op["insert"];
                              print(insert);
                              print("block: $op");

                              if (attributes != null && attributes.containsKey("link")) {
                                contentWidgets.add(Text("Aqui vendria una imagen: $insert"));
                                print("entro algo aca");
                              } else {
                                //Toca insertar una nueva lista de contenido, y ahí se meten las cosas
                                contentWidgets.add(Text(insert));

                              }


                            }



                            return Container(
                                height: 500,
                                child:quill.QuillEditor(
                                  expands: true,
                                  scrollController: _scrollController,
                                  focusNode: _focusNode,
                                  scrollable: true,
                                  padding: EdgeInsets.all(30),
                                  controller: quillController,
                                  autoFocus: true,
                                  readOnly: true, // Para que el contenido sea solo de lectura
                                  embedBuilders: [
                                    ...FlutterQuillEmbeds.builders(),
                                    TimeStampEmbedBuilderWidget()
                                  ],

                                )
                            );

                            print("listsa de widgets $contentWidgets");
    },
                        ),

                      );
                    }
                ),
              ],
            )
        )
      ],
    );
  }

  Widget renderLatex(String latexCode) {
    return TeXView(
      renderingEngine: TeXViewRenderingEngine.katex(),
      child: TeXViewDocument(latexCode),
    );
  }

  void addcontenido() async {
    CollectionReference referencecontenido = db.collection("MATERIAS").doc(
        "CALCULO 1").collection("TEMAS").doc(
        "${widget.ordentema}. ${widget.nombretema}").collection("SUBTEMAS")
        .doc(
        "${widget.ordentema}.${widget.ordensubtema}. ${widget.nombresubtema}")
        .collection("CONTENIDO");
    //Contenido newcontenido = Contenido(_controller as String, 1, "escrito");
    // Obtener el contenido del QuillController como un Delta
    quill.Delta delta = _controller.document.toDelta();
    // Obtener el tipo del contenido (por ejemplo, "texto" o "latex")
    String tipo = "texto"; // Por defecto, asumimos que es un contenido de texto
    if (contenidos.isNotEmpty && contenidos.last.contenido.first.containsKey("latex")) {
      tipo = "latex"; // Si el último contenido agregado es LaTeX, establecemos el tipo como "latex"
    }
    // Convertir el Delta en una lista serializable utilizando JSON
    List<Map<String, dynamic>> serializedDelta = delta
        .map((op) => op.toJson()) // Convertir cada operación en un mapa JSON
        .toList();
    // Crear un mapa que contiene los datos del contenido
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
    // Insertar el contenido LaTeX en la posición actual del cursor
    _controller.replaceText(currentPosition, 0, newLatex, TextSelection.collapsed(offset: currentPosition + newLatex.length),);
    // Agregar el contenido LaTeX como tipo "latex" a la lista contenidos
    setState(() {
      contenidos.add(Contenido(newLatex as List<Map<String, dynamic>>));
    });


  }

  List<Widget> renderMathExpressions(String content) {
    final List<Widget> widgets = [];

    int start = content.indexOf(r'$');
    int end;
    while (start != -1) {
      end = content.indexOf(r'$', start + 1);
      if (end != -1) {
        final mathExpression = content.substring(start + 1, end);
        widgets.add(Math.tex(mathExpression));
        start = content.indexOf(r'$', end + 1);
      } else {
        break;
      }
    }

    return widgets;
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
    final index = _controller.selection.baseOffset;
    final length = 0;
    _controller.replaceText(index, 0, imageUrl, TextSelection.collapsed(offset: index + length),);
  }

  Widget? myEmbedBuilder(BuildContext context, quill.Embed node, double verticalOffset) {
    if (node.value.type == 'image') {
      final imageUrl = node.value.data['src'] as String?;
      if (imageUrl != null) {
        print("se encontro uina imagen");
        // Devolver una imagen utilizando Image.network
        return Image.network(imageUrl);
      }
    }

    // Si no es una imagen o no tiene una URL válida, retornar null para mantener el embed original.
    return null;
  }


  }



