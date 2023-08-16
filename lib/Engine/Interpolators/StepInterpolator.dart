import 'package:gcode_execution/Engine/Image.dart';
import 'package:gcode_execution/Engine/Interpolators/IInterpolator.dart';

class StepInterpolator extends IInterpolator {
  bool tryGetIntensity(Image image, double x, double y, double? intesity) {
    if (x > image.imageWidth - 1 ||
        y > image.imageHeight - 1 ||
        x < 0 ||
        y < 0) {
      return false;
    }
    intesity =
        image.getImagePixel(x.round().toInt(), y.round().toInt())!.intensity;
    return true;
  }

  double getIntensity(Image image, double x, double y) {
    if (x > image.imageWidth - 1 ||
        y > image.imageHeight - 1 ||
        x < 0 ||
        y < 0) {
      return 0.0;
    }

    return image.getImagePixel(x.round().toInt(), y.round().toInt())!.intensity;
  }

  @override
  // TODO: implement description
  String get description => throw UnimplementedError();
}
