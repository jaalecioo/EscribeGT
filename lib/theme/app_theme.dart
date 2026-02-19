import 'package:flutter/material.dart';

class AppTheme {
  // colores principales
  static const Color verdePizarron = Color.fromARGB(197, 5, 95, 50);
  static const Color cafe = Color(0xFF563232);

  // degradado estandar de la app
  static const LinearGradient degradadoPizarron = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color.fromARGB(180, 5, 95, 50),
      Color.fromARGB(80, 5, 95, 50),
      Color.fromARGB(80, 5, 95, 50),
      Color.fromARGB(180, 5, 95, 50),
    ],
  );

  // decoracion estandar del contenedor principal
  static BoxDecoration contenedorPrincipal = BoxDecoration(
    color: verdePizarron,
    border: Border.all(color: cafe, width: 30),
  );

  // decoracion del borde en board
  static BoxDecoration bordeBoard = BoxDecoration(
    border: Border.all(color: cafe, width: 20),
  );
}