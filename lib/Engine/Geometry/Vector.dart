import 'dart:math';

class Vector {
  static double getLength(Vector a, Vector b) {
    return sqrt(pow(a.x - b.x, 2) + pow(a.y - b.y, 2));
  }

  final double _x;
  final double _y;
  double get x => _x;
  double get y => _y;

  Vector(this._x, this._y);

  Vector operator -(Vector other) {
    return Vector(x - other.x, y - other.y);
  }

  Vector operator +(Vector other) {
    return Vector(x + other.x, y + other.y);
  }

  Vector multiply(Vector other) {
    return Vector(x * other.x, y * other.y);
  }

  Vector multiplyByScalar(double scalar) {
    return Vector(x * scalar, y * scalar);
  }

  double? _length;

  double get length {
    _length ??= sqrt(x * x + y * y);
    return _length!;
  }

  Vector normalize() {
    return Vector(x / length, y / length);
  }

  Vector reverse() {
    return Vector(-x, -y);
  }

  Vector rotate(double angle) {
    return Vector(
      x * cos(angle) - y * sin(angle),
      y * cos(angle) + x * sin(angle),
    );
  }

  Vector rotate90CCW() {
    return Vector(-y, x);
  }

  double getAngle() {
    return atan2(y, x);
  }
}
