import 'package:gcode_execution/Engine/GCodeGeneration/BaseGCode.dart';
import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/FreeMotionStroke.dart';
import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/MotionFactoryImage.dart';

class GCodeGenerator {
  late int _maxPower;
  late int _maxFeed;
  late Iterable<FreeMotionStroke> _strokes;
  late int _minPower;
  late int _minFeed;

  GCodeGenerator(Iterable<FreeMotionStroke> strokes, int minFeed, int feed,
      int maxPower, int minPower) {
    _minFeed = minFeed;
    _minPower = minPower;
    _strokes = strokes;
    _maxFeed = feed;
    _maxPower = maxPower;
  }
  Iterable<BaseGCode> generateCode() sync* {
    MotionFactoryImage mf =
        new MotionFactoryImage(_minFeed, _maxFeed, _maxPower, _minPower);

    for (var stroke in _strokes)
      for (var item in mf.createMotion(stroke)) yield item;
  }
}
