import 'dart:math';

import 'package:gcode_execution/Engine/GCodeGeneration/ImageProcessor/FreeMotionStroke.dart';
import "./FreeMotionStroke.dart";
import "../../Geometry/Vector.dart";

class Stroke extends FreeMotionStroke {
  late double intensity;

  Stroke(Vector? destinationPoint, double intensity) : super(destinationPoint) {
    this.intensity = intensity;
  }
}
