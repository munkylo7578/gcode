import 'package:gcode_execution/Engine/Image.dart';
import 'package:gcode_execution/Engine/Interpolators/IInterpolator.dart';
import 'package:gcode_execution/Engine/Pixel.dart';

class BilinearInterpolator extends IInterpolator {
  @override
  double getIntensity(Image image, double x, double y) {
    if (x > image.imageWidth - 1 ||
        y > image.imageHeight - 1 ||
        x < 0 ||
        y < 0) {
      return 0.0;
    }

    int x0 = x.toInt();
    int y0 = y.toInt();

    Pixel? p01 = image.getImagePixel(x0, y0 + 1);
    Pixel? p11 = image.getImagePixel(x0 + 1, y0 + 1);
    Pixel? p10 = image.getImagePixel(x0 + 1, y0);
    Pixel? p00 = image.getImagePixel(x0, y0);

    if (p00 == null || p01 == null || p10 == null || p11 == null) {
      return linearInterpolate(
          p00 ?? p01 ?? p10 ?? p11!, p11 ?? p10 ?? p01 ?? p00!, x, y);
    }

    var k1 = (x0 + 1 - x) * (y0 + 1 - y);
    var k2 = (x - x0) * (y0 + 1 - y);
    var k3 = (x0 + 1 - x) * (y - y0);
    var k4 = (x - x0) * (y - y0);

    var color = k1 * p00.intensity +
        k2 * p10.intensity +
        k3 * p01.intensity +
        k4 * p11.intensity;

    //var color = ((x0 + 1 - x) * (y0 + 1 - y)) * p00.Intensity + ((x - x0) * (y0 + 1 - y)) * p10.Intensity + ((x0 + 1 - x) * (y - y0)) * p01.Intensity + ((x - x0) * (y - y0)) * p11.Intensity;

    return color;
  }

  @override
  bool tryGetIntensity(Image image, double x, double y, double? intensity) {
    if (x > image.imageWidth - 1 ||
        y > image.imageHeight - 1 ||
        x < 0 ||
        y < 0) {
      intensity = 0.0;
      return false;
    }

    int x0 = x.toInt();
    int y0 = y.toInt();

    Pixel? p01 = image.getImagePixel(x0, y0 + 1);
    Pixel? p11 = image.getImagePixel(x0 + 1, y0 + 1);
    Pixel? p10 = image.getImagePixel(x0 + 1, y0);
    Pixel? p00 = image.getImagePixel(x0, y0);

    if (p00 == null || p01 == null || p10 == null || p11 == null) {
      intensity = linearInterpolate(
          p00 ?? p01 ?? p10 ?? p11!, p11 ?? p10 ?? p01 ?? p00!, x, y);
      return true;
    }

    var k1 = (x0 + 1 - x) * (y0 + 1 - y);
    var k2 = (x - x0) * (y0 + 1 - y);
    var k3 = (x0 + 1 - x) * (y - y0);
    var k4 = (x - x0) * (y - y0);

    var color = k1 * p00.intensity +
        k2 * p10.intensity +
        k3 * p01.intensity +
        k4 * p11.intensity;

    //var color = ((x0 + 1 - x) * (y0 + 1 - y)) * p00.Intensity + ((x - x0) * (y0 + 1 - y)) * p10.Intensity + ((x0 + 1 - x) * (y - y0)) * p01.Intensity + ((x - x0) * (y - y0)) * p11.Intensity;

    intensity = color;
    return true;
  }

  //эта штука нужна, если мы попали на границу нашей картинки. Мы не можем взять 4 точки для интерполяции, поэтому берём только две
  double linearInterpolate(Pixel first, Pixel second, double x, double y) {
    if (first == null || second == null) {
      return (first ?? second).intensity;
    }

    if (first.y == second.y) {
      return ((second.x - x) * first.intensity +
              (x - first.x) * second.intensity)
          .abs();
    }
    if (first.x == second.x) {
      return ((second.y - y) * first.intensity +
              (y - first.y) * second.intensity)
          .abs();
    }

    throw Exception("Somthing wrong :)");
  }

  @override
  // TODO: implement description
  String get description => throw UnimplementedError();
}
