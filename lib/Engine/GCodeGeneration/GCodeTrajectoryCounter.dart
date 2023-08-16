import 'dart:math';

import "../GCodeGeneration/BaseGCode.dart";
import "../GCodeGeneration/BaseMotion.dart";
import "../GCodeGeneration/CoordinateMotion.dart";

class GCodeTrajectoryCounter {
  late double rapid;
  late double feed;
  late Duration estimatedTime;
  late Iterable<BaseGCode> _gcode;

  GCodeTrajectoryCounter(Iterable<BaseGCode> gcode) {
    _gcode = gcode;
  }

  void count() {
    rapid = 0;
    feed = 0;
    double durationMin = 0.0;

    BaseMotion? prevMotion;
    for (var gc in _gcode) {
      if (gc is! BaseMotion) continue;
      BaseMotion curMotion = gc as BaseMotion;

      if (prevMotion != null) {
        double distance = (curMotion.position! - prevMotion.position!).length;
        if (curMotion is CoordinateMotion) {
          feed += distance;
          durationMin += distance / curMotion.feed;
        } else {
          rapid += distance;
          durationMin += distance / 20000;
        }
      }
      prevMotion = curMotion;
    }
    estimatedTime = Duration(minutes: durationMin.toInt());
  }
}
