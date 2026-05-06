import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

///This code decodes a downscaled version of the image
/// to efficiently extract its dominant color,
/// minimizing CPU and memory usage while avoiding UI thread blocking.
Future<Color> extractDominantColor(Uint8List imageBytes) async {
  final codec = await ui.instantiateImageCodec(
    imageBytes,
    targetWidth: 100,
    targetHeight: 100,
  );

  final frame = await codec.getNextFrame();
  final image = frame.image;

  final palette = await PaletteGenerator.fromImage(image, maximumColorCount: 8);

  return palette.dominantColor?.color ?? Colors.black;
}
