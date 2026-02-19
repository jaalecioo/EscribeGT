import 'dart:typed_data';
import 'package:image/image.dart' as img;

import 'scoring_config.dart';
import '../utils/image_utils.dart';

double compararImagenesMejorada(
  Uint8List bytesU,
  Uint8List bytesR,
  int edad,
) {
  img.Image? rawU = img.decodeImage(bytesU);
  img.Image? rawR = img.decodeImage(bytesR);

  if (rawU == null || rawR == null) return 0.0;

  final croppedU = recortarSoloTrazo(rawU);
  final croppedR = recortarSoloTrazo(rawR);

  final canvasR = croppedR;
  final canvasU = img.copyResize(
    croppedU,
    width: canvasR.width,
    height: canvasR.height,
    interpolation: img.Interpolation.average,
  );

  int aciertos = 0;
  int pixelesGuiaTotal = 0;
  int pixelesFuera = 0;

  final tolerancia = toleranciaPorEdad(edad);
  final benevolencia = factorBenevolencia(edad);
  final umbral = umbralExitoPorEdad(edad);
  final maximo = maximoPorEdad(edad);

  for (int y = 0; y < canvasR.height; y += 2) {
    for (int x = 0; x < canvasR.width; x += 2) {
      final pR = canvasR.getPixel(x, y);
      final esGuia = pR.a > 20;

      if (esGuia) {
        pixelesGuiaTotal++;
        if (verificarPintadoCerca(canvasU, x, y, tolerancia)) {
          aciertos++;
        }
      } else if (canvasU.getPixel(x, y).a > 50) {
        pixelesFuera++;
      }
    }
  }

// evita division entre cero si la imagen de referencia esta en blanco
  if (pixelesGuiaTotal == 0) return 0.0;

  final cobertura = aciertos / pixelesGuiaTotal;
  final penalizacion = (pixelesFuera / (pixelesGuiaTotal + 1)) * benevolencia;

  double puntaje = (cobertura - penalizacion).clamp(0.0, 1.0);

  // Bonus proporcional en lugar de fijo
  // Amplifica el puntaje real según la edad, sin inventar rendimiento
  final factorAmplificacion = edad <= 3
      ? 1.45 // amplifica 45% lo que ya logró
      : edad == 4
          ? 1.30 // amplifica 30%
          : edad == 5
              ? 1.15 // amplifica 15%
              : 1.05; // 6 años, mínima amplificación

  if (puntaje < umbral) {
    puntaje = (puntaje * factorAmplificacion).clamp(0.0, maximo);
  }

  return puntaje.clamp(0.0, maximo);
}
