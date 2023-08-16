import './Vector.dart';

class Line {
  late double A;
  late double B;
  late double C;

  Line(Vector normalVector, Vector pointToCross) {
    A = normalVector.x;
    B = normalVector.y;

    C = -(A * pointToCross.x + B * pointToCross.y);
  }

  Line.fromVector(Vector normalVector) : this(normalVector, normalVector);

  double getX(double Y) {
    return (-C - B * Y) / A;
  }

  double getY(double X) {
    return (-C - A * X) / B;
  }

  static Vector getIntersection(Line l1, Line l2) {
    double denominator = l1.A * l2.B - l2.A * l1.B;
    double x = -(l1.C * l2.B - l2.C * l1.B) / denominator;
    double y = -(l1.A * l2.C - l2.A * l1.C) / denominator;
    return Vector(x, y);
  }
}
