int toleranciaPorEdad(int edad) {
  if (edad <= 3) return 35;
  if (edad == 4) return 28;
  if (edad == 5) return 22;
  return 18;
}

double factorBenevolencia(int edad) {
  if (edad <= 3) return 0.35;
  if (edad == 4) return 0.25;
  if (edad == 5) return 0.15;
  return 0.08;
}

double umbralExitoPorEdad(int edad) {
  if (edad <= 3) return 0.55;
  if (edad == 4) return 0.65;
  if (edad == 5) return 0.75;
  return 0.85;
}

double maximoPorEdad(int edad) {
  if (edad <= 3) return 0.85;
  if (edad == 4) return 0.92;
  return 1.0;
}
