import 'dart:math';
import 'package:image/image.dart' as img;

bool verificarPintadoCerca(
  img.Image imgUser,
  int centerX,
  int centerY,
  int radio,
) {
  for (int dy = -radio; dy <= radio; dy++) {
    for (int dx = -radio; dx <= radio; dx++) {
      final nx = centerX + dx;
      final ny = centerY + dy;

      if (nx >= 0 &&
          nx < imgUser.width &&
          ny >= 0 &&
          ny < imgUser.height) {
        if (imgUser.getPixel(nx, ny).a > 50) return true;
      }
    }
  }
  return false;
}

img.Image recortarSoloTrazo(img.Image src) {
  int minX = src.width, minY = src.height, maxX = 0, maxY = 0;
  bool tieneContenido = false;

  for (int y = 0; y < src.height; y++) {
    for (int x = 0; x < src.width; x++) {
      final p = src.getPixel(x, y);
      if (p.a > 30 && p.luminance < 0.9) {
        minX = min(minX, x);
        minY = min(minY, y);
        maxX = max(maxX, x);
        maxY = max(maxY, y);
        tieneContenido = true;
      }
    }
  }

  if (!tieneContenido) return src;

  return img.copyCrop(
    src,
    x: max(0, minX - 5),
    y: max(0, minY - 5),
    width: min(src.width, (maxX - minX) + 10),
    height: min(src.height, (maxY - minY) + 10),
  );
}
