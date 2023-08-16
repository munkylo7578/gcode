import 'package:gcode_execution/Core/Bitmap.dart';
import 'package:gcode_execution/Engine/Interpolators/IInterpolator.dart';
import 'package:gcode_execution/Engine/Pixel.dart';

class Image {
  late List<List<Pixel?>> _pixels;
  late IInterpolator _interpolator;
  late double width;
  late double height;
  late double scaleHorizontal;
  late double scaleVertical;
  int get imageWidth => _pixels.length;

  int get imageHeight => _pixels[0].length;

  Image(
      double width, double height, Bitmap bitmap, IInterpolator? interpolator) {
    if (interpolator == null) {
      throw ArgumentError("interpolator is null.");
    }
    if (bitmap == null) {
      throw ArgumentError("bitmap is null.");
    }
    if (width < 0) {
      throw Exception("Width can't be negative");
    }
    if (height < 0) {
      throw Exception("Height can't be negative");
    }

    this.width = width;
    this.height = height;
    this.scaleHorizontal = (bitmap.width - 1) / this.width;
    this.scaleVertical = (bitmap.height - 1) / this.height;
    _pixels = List.generate(
        bitmap.width, (x) => List.generate(bitmap.height, (y) => null));
    _interpolator = interpolator;
    for (int x = 0; x < bitmap.width; x++) {
      for (int y = 0; y < bitmap.height; y++) {
        var pixelColor = bitmap.getPixel(x, bitmap.height - y - 1);
        double luminance = pixelColor.computeLuminance();
        _pixels[x][y] =
            Pixel.withIntensity(luminance, x.toDouble(), y.toDouble());
      }
    }
  }

  Pixel? getPixel(double x, double y) {
    double intens = _interpolator.getIntensity(
        this, x * scaleHorizontal, y * scaleVertical);
    if (!_interpolator.tryGetIntensity(
        this, x * scaleHorizontal, y * scaleVertical, null)) {
      return null;
    }

    return Pixel.withIntensity(intens, x, y);
  }

  Pixel? getImagePixel(int x, int y) {
    if (x < 0 || y < 0 || x > imageWidth - 1 || y > imageHeight - 1) {
      return null;
    }
    return _pixels[x][y];
  }
}
