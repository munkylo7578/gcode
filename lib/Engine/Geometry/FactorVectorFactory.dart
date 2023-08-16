import 'dart:math';

import './Vector.dart';

class FactorVectorFactory {
  late double _factorX;
  late double _factorY;

  FactorVectorFactory(double factorX, double factorY) {
    _factorX = factorX;
    _factorY = factorY;
  }

  Vector create(Vector v) {
    return Vector(v.x * _factorX, v.y * _factorY);
  }

  Vector createWithPointF(Point p) {
    return Vector(p.x * _factorX, p.y * _factorY);
  }

  Vector createWithValues(double x, double y) {
    return Vector(x * _factorX, y * _factorY);
  }
}
