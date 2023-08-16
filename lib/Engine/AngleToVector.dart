import 'dart:math';
import "./Geometry/Vector.dart";

class AngleToVector {
  static double degToRad(double deg) {
    return deg / 180.0 * pi;
  }

  static Vector getNormal(double angle) {
    return Vector(cos(angle), sin(angle));
  }

  static double getAngle(Vector v) {
    return acos(v.normalize().x);
  }
}
