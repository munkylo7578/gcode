import 'package:gcode_execution/Engine/Geometry/ImageLine.dart';
import 'package:gcode_execution/Engine/Geometry/Line.dart';
import 'package:gcode_execution/Engine/Geometry/Vector.dart';
import 'package:gcode_execution/Engine/Image.dart';
import 'package:gcode_execution/Engine/Pixel.dart';

class ImageByLinesPresenter {
  late List<Pixel> _pixels;
  late Image _image;
  Image get image => _image;
  late double lineResolution;
  late List<ImageLine> _lines;
  List<ImageLine> get lines => _lines;

  ImageByLinesPresenter(Image image) {
    _image = image;
    _lines = <ImageLine>[];
  }
  void present(
      Vector normalVector, double lineResolution, double pointResolution) {
    lineResolution = lineResolution;
    lines.clear();
    Vector vectorIncrement =
        normalVector.normalize().multiplyByScalar(lineResolution);

    Vector startingPoint;
    Vector endPoint;
    Vector currentVector;
    if (vectorIncrement.x <
        0) //для углов 91-180 рисуем, начиная с левого верхнего края - координата (0, Ymax)
    {
      startingPoint = Vector(0, image.height);
      endPoint = Vector(image.width, 0);
      vectorIncrement = vectorIncrement.reverse();
      currentVector = Line.getIntersection(Line(vectorIncrement, startingPoint),
          Line(Vector(-vectorIncrement.y, vectorIncrement.x), Vector(0, 0)));
    } else // для углов 0-90 с точки (0,0)
    {
      startingPoint = Vector(0, 0);
      endPoint = Vector(image.width, image.height);
      currentVector = vectorIncrement;
    }

    lines.add(ImageLine(vectorIncrement, startingPoint, image));
    var borderLine = Line(vectorIncrement, endPoint);
    var incrementLine =
        Line(Vector(-vectorIncrement.y, vectorIncrement.x), Vector(0, 0));
    var intersection = Line.getIntersection(borderLine, incrementLine);
    while (currentVector.x <= intersection.x &&
        (currentVector.y * intersection.y < 0 ||
            currentVector.y.abs() <= intersection.y.abs())) {
      lines.add(ImageLine.fromNormal(currentVector, image));
      currentVector += vectorIncrement;
    }

    for (var item in lines) {
      item.generatePixels(pointResolution);
    }
  }
}
