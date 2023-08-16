import 'package:gcode_execution/Core/Bitmap.dart';
import 'package:gcode_execution/Engine/AngleToVector.dart';
import 'package:gcode_execution/Engine/Geometry/Vector.dart';
import 'package:gcode_execution/Engine/Image.dart';
import 'package:gcode_execution/Engine/ImageByLinesPresenter.dart';
import 'package:gcode_execution/Engine/Interpolators/IInterpolator.dart';

class ImageProcessor {
  late Image _image;
  late double _width;
  late double _height;
  late double _lineRes;
  late double _pointRes;
  late double _angle;
  ImageProcessor(Bitmap bitmap, double width, double height, double lineRes,
      double pointRes, double angle, IInterpolator? interpolator) {
    if (width < 0) {
      throw Exception("Width can not be negative");
    }
    if (height < 0) {
      throw Exception("Height can not be negative");
    }
    if (lineRes < 0) {
      throw Exception("lineRes can not be negative");
    }
    if (pointRes < 0) {
      throw Exception("pointRes can not be negative");
    }
    _angle = angle;
    _pointRes = pointRes;
    _lineRes = lineRes;
    _height = height;
    _width = width;
    _image = new Image(width, height, bitmap, interpolator);
  }
  ImageByLinesPresenter createPresenter() {
    var ip = ImageByLinesPresenter(_image);

    var angleInRadian = AngleToVector.degToRad(_angle);
    var mathVector = AngleToVector.getNormal(angleInRadian);
    var resultingVector =
        Vector(mathVector.x.roundToDouble(), mathVector.y.roundToDouble());

    ip.present(resultingVector, _lineRes, _pointRes);

    return ip;
  }
}
