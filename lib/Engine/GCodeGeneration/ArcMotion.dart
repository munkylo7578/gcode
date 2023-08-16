import 'package:flutter/material.dart';
import '../GCodeGeneration/CoordinateMotion.dart';

import '../Geometry/Vector.dart';

class ArcMotion extends CoordinateMotion {
  late double r;
  late bool isClockWise;

  ArcMotion(Vector position, double r, int intensity, int feed, Color color)
      : super(position, intensity, feed, color) {
    this.r = r;
  }
}
