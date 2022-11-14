import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/flutter_flow_theme.dart';
import 'package:flutter/flutter_flow_count_controller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/flutter_flow_widgets.dart';
import 'screens/levels.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INICIO',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(title: 'INICIO'),
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
  int? edadValue = 3;
  double radius = 2.00;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              child: Stack(children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(350, 150, 200, 200),
                  child: Text(
                    '¿Cuántos años tienes?',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).title1.override(
                          fontFamily: 'Handlee',
                          color: Colors.white,
                          fontSize: 60,
                        ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 200,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0x00FFFFFF),
                      borderRadius: BorderRadius.circular(25),
                      shape: BoxShape.rectangle,
                    ),
                    child: FlutterFlowCountController(
                      decrementIconBuilder: (enabled) => FaIcon(
                        FontAwesomeIcons.minus,
                        color: enabled
                            ? Color(0xDDFF0000)
                            : Color.fromARGB(255, 255, 0, 0),
                        size: 40,
                      ),
                      incrementIconBuilder: (enabled) => FaIcon(
                        FontAwesomeIcons.plus,
                        color: Colors.blue,
                        size: 40,
                      ),
                      countBuilder: (count) => Text(
                        count.toString(),
                        style: GoogleFonts.getFont(
                          'Roboto',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                        ),
                      ),
                      count: edadValue ??= 3,
                      updateCount: (count) => setState(() => edadValue = count),
                      maximum: 6,
                      minimum: 1,
                    ),
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0, 0.5),
                  child: FFButtonWidget(
                    onPressed: () => {Navegar()},
                    text: 'Entrar',
                    options: FFButtonOptions(
                      width: 200,
                      height: 100,
                      color: Color(0xFF563232),
                      textStyle: FlutterFlowTheme.of(context)
                          .subtitle2
                          .override(
                              fontFamily: 'Handlee',
                              color: Colors.white,
                              fontSize: 50),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      //borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )
              ]),
            )));
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
}
