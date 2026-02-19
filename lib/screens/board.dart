import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:EscribeGT/screens/levels.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scribble/scribble.dart';

import '../scoring/scoring_engine.dart';
import '../theme/app_theme.dart';

class MyBoard extends StatefulWidget {
  const MyBoard({
    super.key,
    required this.title,
    required this.url,
    required this.edad,
  });

  final String title;
  final String url;
  final int edad;

  @override
  State<MyBoard> createState() => _Board();
}

class _Board extends State<MyBoard> {
  final ScribbleNotifier notifier = ScribbleNotifier();
  Uint8List? _imagenReferenciaCache;
  int get edadUsuario => widget.edad;

  @override
  void initState() {
    super.initState();
    _precargarImagen();
  }

  Future<void> _precargarImagen() async {
    try {
      final bytes = await _urlToBytes(widget.url);
      if (mounted) setState(() => _imagenReferenciaCache = bytes);
    } catch (_) {
      // si falla la precarga se intentara al calificar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // imagen de referencia como fondo
          Positioned.fill(
            child: Image.network(
              widget.url,
              fit: BoxFit.contain,
              color: Colors.white.withValues(alpha: 0.15),
              colorBlendMode: BlendMode.modulate,
              errorBuilder: (_, __, ___) => Container(
                color: const Color.fromARGB(197, 5, 95, 50),
              ),
            ),
          ),

          // degradado verde encima de la imagen
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: AppTheme.degradadoPizarron,
              ),
            ),
          ),

          // borde café
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color(0xFF563232),
                  width: 20,
                ),
              ),
            ),
          ),

          // área de trazado ocupa toda la pantalla
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Scribble(notifier: notifier, drawPen: true),
            ),
          ),

          // toolbar lateral derecho
          Positioned(
            top: 40,
            right: 30,
            child: _buildColorToolbar(context),
          ),

          // encabezado arriba izquierda
          Positioned(
            top: 30,
            left: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.cafe.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: GoogleFonts.handlee(
                      color: Colors.amber,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '¡Copia el trazo de fondo!',
                    style: GoogleFonts.handlee(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // boton volver abajo izquierda
          Positioned(
            bottom: 30,
            left: 30,
            child: FloatingActionButton(
              heroTag: "btnBack",
              backgroundColor: const Color(0xFF563232),
              onPressed: () => Navigator.of(context).pop(),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _calificaEjercicio(BuildContext context) async {
    final image = await notifier.renderImage();
    final Uint8List trazosUsuario = image.buffer.asUint8List();

    double porcentaje = 0.0;

    try {
      final Uint8List imagenReferencia =
          _imagenReferenciaCache ?? await _urlToBytes(widget.url);

      final similitud = compararImagenesMejorada(
        trazosUsuario,
        imagenReferencia,
        edadUsuario,
      );

      porcentaje = similitud * 100;
    } catch (_) {
      // distinguimos entre no intento y fallo tecnico
      final tieneSuficienteTrazo =
          notifier.currentSketch.lines.any((linea) => linea.points.length > 10);
      final tieneTrazos = notifier.currentSketch.lines.isNotEmpty;

      porcentaje = tieneSuficienteTrazo
          ? 40.0
          : tieneTrazos
              ? 20.0
              : 5.0;
    }

    FirebaseFirestore.instance.collection("aplicacion").add({
      "edad": edadUsuario,
      "fecha": DateTime.now(),
      "punteo": porcentaje.round(),
      "ejercicio": widget.title,
    });

    if (!mounted) return;
    _mostrarDialogoExito(context, porcentaje);
  }

  Future<Uint8List> _urlToBytes(String url) async {
    final imageProvider = NetworkImage(url);
    final completer = Completer<ui.Image>();
    final stream = imageProvider.resolve(const ImageConfiguration());

    stream.addListener(
      ImageStreamListener((info, _) => completer.complete(info.image)),
    );

    final uiImage = await completer.future;
    final byteData = await uiImage.toByteData(
      format: ui.ImageByteFormat.png,
    );
    return byteData!.buffer.asUint8List();
  }

  void _mostrarDialogoExito(BuildContext context, double porcentaje) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('¡Buen trabajo!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Tu puntaje: ${porcentaje.toStringAsFixed(0)}%'),
            const SizedBox(height: 10),
            Text(
              porcentaje > 70
                  ? "¡Eres un artista! 🌟"
                  : "¡Sigue practicando! 💪",
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('CONTINUAR'),
            onPressed: () {
              Navigator.of(context).pop();
              _navegar();
            },
          ),
        ],
      ),
    );
  }

  void _navegar() async {
    var col = FirebaseFirestore.instance.collection("Leccion");
    var a = await col.orderBy("Detalle").get();

    var nivel = a.docs
        .map((d) => level(d.get("Detalle"), d.get("Link_imagen")))
        .toList();

    if (!mounted) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => levelsScreen(
          levelss: nivel,
          edad: edadUsuario,
        ),
      ),
    );
  }

  Widget _buildColorToolbar(BuildContext context) {
    return ListenableBuilder(
      listenable: notifier,
      builder: (context, _) {
        final state = notifier.value;
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _buildToolButton(
                icon: Icons.undo,
                tooltip: "Deshacer",
                onPressed: notifier.canUndo ? notifier.undo : null,
              ),
              _buildToolButton(
                icon: Icons.delete_forever,
                tooltip: "Borrar todo",
                onPressed: notifier.clear,
              ),
              const Divider(color: Colors.white, height: 20),
              _buildColorCircle(
                  color: Colors.black, label: "Negro", state: state),
              _buildColorCircle(
                  color: Colors.blue, label: "Azul", state: state),
              _buildColorCircle(color: Colors.red, label: "Rojo", state: state),
              const Divider(color: Colors.white, height: 20),
              _buildCheckButton(context),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback? onPressed,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Tooltip(
        message: tooltip,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: onPressed != null
                  ? Colors.white.withValues(alpha: 0.25)
                  : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: onPressed != null ? Colors.white : Colors.white38,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildColorCircle({
    required Color color,
    required String label,
    required ScribbleState state,
  }) {
    final isSelected =
        state is Drawing && state.selectedColor == color.toARGB32();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Tooltip(
        message: label,
        child: GestureDetector(
          onTap: () => notifier.setColor(color),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: isSelected ? 52 : 44,
            height: isSelected ? 52 : 44,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.yellow : Colors.white,
                width: isSelected ? 4 : 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: Colors.yellow.withValues(alpha: 0.6),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 22)
                : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCheckButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Tooltip(
        message: "Calificar",
        child: GestureDetector(
          onTap: () => _calificaEjercicio(context),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.greenAccent[700],
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withValues(alpha: 0.5),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(Icons.check, color: Colors.white, size: 34),
          ),
        ),
      ),
    );
  }
}
