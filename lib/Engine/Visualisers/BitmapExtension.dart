import 'dart:ui';

import 'package:gcode_execution/Core/Bitmap.dart';

class BitmapExtensions {
  late Bitmap _image;

  Bitmap get image => _image;

  BitmapExtensions(Bitmap image) {
    _image = image;
  }

  void setPixel(int x, double y, Color color) async {
    if (x > _image.width - 1 || y > _image.height - 1) {
      throw Exception('Point out of Dimensions');
    }

    if (y == y.toInt()) {
      Color p = await _image.getPixel(x, y.toInt());
      p = Color.fromRGBO(
        mix(p.red, color.red, 1),
        mix(p.green, color.green, 1),
        mix(p.blue, color.blue, 1),
        1,
      );

      return;
    }

    Color p1 = await _image.getPixel(x, y.toInt());
    Color p2 = await _image.getPixel(x, y.toInt() + 1);

    double k = y - y.toInt().toDouble();

    p1 = Color.fromRGBO(
      mix(p1.red, color.red, k),
      mix(p1.green, color.green, k),
      mix(p1.blue, color.blue, k),
      1,
    );
    p2 = Color.fromRGBO(
      mix(p2.red, color.red, 1 - k),
      mix(p2.green, color.green, 1 - k),
      mix(p2.blue, color.blue, 1 - k),
      1,
    );
  }

  int mix(int native, int mixed, double k) {
    return ((native + mixed * k) / 2.0).round();
  }
}
