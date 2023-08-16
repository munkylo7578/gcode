import 'package:gcode_execution/Engine/Geometry/Line.dart';
import 'package:gcode_execution/Engine/Geometry/Vector.dart';
import 'package:gcode_execution/Engine/Image.dart';
import 'package:gcode_execution/Engine/Interpolators/IInterpolator.dart';
import 'package:gcode_execution/Engine/Pixel.dart';

class ImageLine extends Line {
  int count = 0;
  late Image _image;
  late List<Pixel?> _pixels;
  List<Pixel?> get pixels => _pixels;
  ImageLine(Vector normalVector, Vector pointToCross, Image image)
      : super(normalVector, pointToCross) {
    _pixels = <Pixel>[];
    _image = image;
  }
  ImageLine.fromNormal(Vector normalVector, Image image)
      : this(normalVector, normalVector, image);
  void generatePixels(double pointResolution) {
    Vector directionVector =
        Vector(-super.B, super.A).normalize().multiplyByScalar(pointResolution);
    if (directionVector.x < 0) {
      directionVector = directionVector.reverse();
    }
    var currentVector = getFirstVector();
    Pixel? temp = _image.getPixel(currentVector.x, currentVector.y);

    while (temp != null) {
      _pixels.add(temp);
      currentVector += directionVector;
      temp = _image.getPixel(currentVector.x, currentVector.y);
    }
    var lastAddedVector = currentVector - directionVector;
    var lastVector = getLastVector();
    if (lastAddedVector.x != lastVector.x &&
        lastAddedVector.y != lastVector.y) {
      _pixels.add(_image.getPixel(lastVector.x, lastVector.y));
    }
  }

  Vector getLastVector() {
    if (B == 0) {
      return Vector(-C / B, _image.height);
    }

    double x = _image.width;
    double y = super.getY(x);

    if (y > _image.height) {
      y = _image.height;
      x = super.getX(y);
    } else if (y < 0) {
      y = 0;
      x = super.getX(y);
    }

    return Vector(x, y);
  }

  Vector getFirstVector() {
    if (B == 0) {
      return Vector(-C / A, 0);
    }

    double x = 0.0;
    double y = super.getY(x);

    if (y > _image.height) {
      y = _image.height;
      x = super.getX(y);
    } else if (y < 0) {
      y = 0;
      x = super.getX(y);
    }

    return Vector(x, y);
  }
}
