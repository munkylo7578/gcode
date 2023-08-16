import "../Geometry/Vector.dart";

class VisualLine {
  final Vector _v1;
  final Vector _v2;
  final double _intensity;

  Vector get v1 => _v1;
  Vector get v2 => _v2;
  double get intensity => _intensity;

  VisualLine.fromCoordinates(
      double x1, double x2, double y1, double y2, double intensity)
      : this(Vector(x1, y1), Vector(x2, y2), intensity);

  VisualLine(Vector v1, Vector v2, double intensity)
      : _v1 = v1,
        _v2 = v2,
        _intensity = intensity;
}
