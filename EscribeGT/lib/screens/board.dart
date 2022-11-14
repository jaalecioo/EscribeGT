import 'package:EscribeGT/screens/levels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribble/scribble.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:image_compare/image_compare.dart';
import 'package:firebase_core/firebase_core.dart';

class MyBoard extends StatefulWidget {
  const MyBoard({super.key, required this.title, required this.url});
  final String title;
  final String url;

  @override
  State<MyBoard> createState() => _Board();
}

class _Board extends State<MyBoard> {
  final ScribbleNotifier notifier = ScribbleNotifier();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          leading: IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Finalizar ejercicio",
            onPressed: () => _calificaEjercicio(context),
          ),
        ),
        body: Material(
          color: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(1),
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color.fromARGB(197, 5, 95, 50),
              borderRadius: BorderRadius.circular(1),
              border: Border.all(
                color: Color(0xFF563232),
                width: 30,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Text(
                          'Trazado de Ejemplo',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.getFont(
                            'Handlee',
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.w600,
                            fontSize: 25,
                          ),
                        ),
                      ),
                    ),
                    Image.network(
                      widget.url,
                      //'http://10.0.2.2:9199/v0/b/trazado-41aa1.appspot.com/o/aa.jpg?alt=media&token=bf1cfe23-b57c-4883-ba1d-8d8148eaa4b4',
                      width: 800,
                      height: 150,
                      fit: BoxFit.scaleDown,
                    ),
                  ],
                ),
                Divider(
                  height: 30,
                  thickness: 10,
                  color: Colors.brown,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        height: 400,
                        width: 400,
                        child: Stack(
                          children: [
                            Scribble(
                              notifier: notifier,
                              drawPen: true,
                            ),
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Column(
                                children: [
                                  _buildColorToolbar(context),
                                  const Divider(
                                    height: 32,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> _calificaEjercicio(BuildContext context) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    //iniciamos la conexion a Firebase
    //uploadImage();
    final image = await notifier.renderImage();
    var a = Uint8List.fromList(image.buffer.asUint8List());
    var b = Uri.parse(widget.url);
    //'http://10.0.2.2:9199/v0/b/trazado-41aa1.appspot.com/o/aa.jpg?alt=media&token=bf1cfe23-b57c-4883-ba1d-8d8148eaa4b4');
    var curve = notifier.currentSketch.lines;
    for (int i = 0; i < curve.length; i++) {
      print('Longitud curva $curve.lenght');
      var puntos = curve[i].points;
      print('Cantidad puntos $puntos.length');
      for (int j = 0; j < puntos.length; j++) {
        print(puntos[j].x);
        print(puntos[j].y);
        print('Cantidad $j');
      }
    }

    var result = await compareImages(
        src1: b, src2: a, algorithm: IntersectionHistogram(ignoreAlpha: true));
    print('Diferencia: ${result * 100}%');
    var valor = (1 - result) * 100;
    print('Resultado: ${valor}%');
    //.refFromURL('http://10.0.2.2:9099/?ns=trazado-41aa1')
    //.ref;
    // DatabaseReference ref = FirebaseDatabase.instance.ref().root;
    var col = FirebaseFirestore.instance.collection("aplicacion");
    col.doc("usuario3").set({
      "edad": 12,
      "Fecha": DateTime.now().toString(),
      "punteo": 75,
      "id": "test01"
    });
    //await ref.update(
    //    {"aplicacion/usuario/Edad": 12, "aplicacion/usuario/Punteo": 75});
    //await ref.set({"Edad": 4, "Fecha": "now", "Punteo": 75, "id": "test01"});
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Felicidades '),
              content: Text('Tu puntaje obtenido es ${74.25}%'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: const Text('OK'),
                  onPressed: () {
                    Navegar();
                    //Navigator.of(context).pop();
                  },
                ),
              ],
            ));
    /*showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Your Image "),
        content: Image.memory(image.buffer.asUint8List()),
      ),
    );*/
  }

  void Navegar() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    var col = FirebaseFirestore.instance.collection("Leccion");

    var a = await col.get();
    var b = a.docs;
    var nivel = <level>[];
    for (int i = 0; i < b.length; i++) {
      nivel.add(new level(b[i].get("Detalle"), b[i].get("Link_imagen")));
    }
    List<level> nivel2 = nivel;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => levelsScreen(levelss: nivel2),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return StateNotifierBuilder<ScribbleState>(
      stateNotifier: notifier,
      builder: (context, state, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildUndoButton(context),
          const Divider(
            height: 1.0,
          ),
          _buildRedoButton(context),
          const Divider(
            height: 1.0,
          ),
          _buildClearButton(context),
          const Divider(
            height: 1.0,
          ),
          _buildEraserButton(context, isSelected: state is Erasing),
          _buildColorButton(context, color: Colors.white, state: state),
          _buildColorButton(context, color: Colors.black, state: state),
        ],
      ),
    );
  }

  Widget _buildEraserButton(BuildContext context, {required bool isSelected}) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
        heroTag: "BuildEraser",
        tooltip: "Erase",
        backgroundColor: Colors.brown,
        elevation: isSelected ? 10 : 2,
        shape: !isSelected
            ? const CircleBorder()
            : RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
        child: const Icon(Icons.remove, color: Colors.white),
        onPressed: notifier.setEraser,
      ),
    );
  }

  uploadImage() async {
    /*final _firebaseStorage = FirebaseStorage.instance.ref("aa.jpg");
    await Permission.photos.request();
    final image = await notifier.renderImage();
    var file = Uint8List.fromList(image.buffer.asUint8List());
    //Reference ref = FirebaseStorage.instance.ref().root;
    //gs://trazado-41aa1.appspot.com/
    UploadTask uploadTask = _firebaseStorage.putData(file);
    print(uploadTask.toString());*/
//    var permissionStatus = await Permission.photos.status;
  }

  Widget _buildColorButton(
    BuildContext context, {
    required Color color,
    required ScribbleState state,
  }) {
    final isSelected = state is Drawing && state.selectedColor == color.value;
    return Padding(
      padding: const EdgeInsets.all(4),
      child: FloatingActionButton.small(
          heroTag: "Color +$color",
          backgroundColor: color,
          elevation: isSelected ? 10 : 2,
          shape: !isSelected
              ? const CircleBorder()
              : RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
          child: Container(),
          onPressed: () => notifier.setColor(color)),
    );
  }

  Widget _buildUndoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      tooltip: "Undo",
      heroTag: "Undo",
      onPressed: notifier.canUndo ? notifier.undo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canUndo ? Colors.brown : Colors.brown,
      child: const Icon(
        Icons.undo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRedoButton(
    BuildContext context,
  ) {
    return FloatingActionButton.small(
      tooltip: "Redo",
      heroTag: "Redo",
      onPressed: notifier.canRedo ? notifier.redo : null,
      disabledElevation: 0,
      backgroundColor: notifier.canRedo ? Colors.brown : Colors.brown,
      child: const Icon(
        Icons.redo_rounded,
        color: Colors.white,
      ),
    );
  }

  Widget _buildClearButton(BuildContext context) {
    return FloatingActionButton.small(
      heroTag: "ClearButton",
      tooltip: "Clear",
      onPressed: notifier.clear,
      disabledElevation: 0,
      backgroundColor: Colors.brown,
      child: const Icon(Icons.clear_sharp, color: Colors.white),
    );
  }
}
