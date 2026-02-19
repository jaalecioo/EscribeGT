import 'package:EscribeGT/theme/app_theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart';
import 'screens/levels.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseFirestore.instance.useFirestoreEmulator('10.0.2.2', 8080);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'INICIO',
      theme: ThemeData(primarySwatch: Colors.brown),
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
  int edadValue = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: AppTheme.contenedorPrincipal,
        child: Stack(
          children: [
            Positioned(
              top: 150,
              left: 350,
              right: 200,
              child: Text(
                '¿Cuántos años tienes?',
                textAlign: TextAlign.center,
                style: GoogleFonts.handlee(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                width: 300,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: edadValue > 1
                          ? () => setState(() => edadValue--)
                          : null,
                      icon: FaIcon(
                        FontAwesomeIcons.minus,
                        color: edadValue > 1 ? Colors.red : Colors.red.shade200,
                        size: 40,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        edadValue.toString(),
                        style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 40,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: edadValue < 6
                          ? () => setState(() => edadValue++)
                          : null,
                      icon: FaIcon(
                        FontAwesomeIcons.plus,
                        color: Colors.blue,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const AlignmentDirectional(0, 0.5),
              child: ElevatedButton(
                onPressed: _navegar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF563232),
                  minimumSize: const Size(200, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                child: Text(
                  'Entrar',
                  style: GoogleFonts.handlee(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navegar() async {
    var col = FirebaseFirestore.instance.collection("Leccion");
    var a = await col.orderBy("Detalle").get();
    var b = a.docs;
    var nivel = <level>[];
    for (int i = 0; i < b.length; i++) {
      nivel.add(level(b[i].get("Detalle"), b[i].get("Link_imagen")));
    }
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => levelsScreen(
          levelss: nivel,
          edad: edadValue,
        ),
      ),
    );
  }
}
