import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gcode_execution/Engine/Pixel.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import "dart:typed_data";

class Cac {}

class Bitmap {
  late ui.Image image;
  ByteData? _byteData;

  ui.Image get _image => image;
  int get width => image.width;
  int get height => image.height;
  Future<ui.Image> fromFile(String path) async {
    _byteData = await rootBundle.load('assets/$path');

    ui.Codec codec =
        await ui.instantiateImageCodec(_byteData!.buffer.asUint8List());
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image image = frameInfo.image;
    _byteData = await image.toByteData();
    return image;
  }

  Color getPixel(int x, int y) {
    if (_byteData == null) {
      throw Exception('Failed to get ByteData from image.');
    }
    final int pixel32 = _byteData!.getInt32((x + y * image.width) * 4);
    final int hex = abgrToArgb(pixel32); // Convert ABGR to ARGB
    return Color(hex);
  }

  int abgrToArgb(int abgrColor) {
    final a = (abgrColor >> 24) & 0xFF;
    final b = (abgrColor >> 16) & 0xFF;
    final g = (abgrColor >> 8) & 0xFF;
    final r = abgrColor & 0xFF;
    return (a << 24) | (r << 16) | (g << 8) | b;
  }
}
