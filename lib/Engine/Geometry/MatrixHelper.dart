import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import './Vector.dart';

class MatrixHelpers {
  static Vector transform(Point p, Matrix4 m) {
    final List<double> elements = m.storage;
    final double a00 = elements[0];
    final double a01 = elements[1];
    final double dX = elements[12];
    final double a10 = elements[4];
    final double a11 = elements[5];
    final double dY = elements[13];

    return Vector(
      p.x * a00 + p.y * a01 + dX,
      p.x * a10 + p.y * a11 + dY,
    );
  }
}
