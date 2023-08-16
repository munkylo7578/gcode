import "./Geometry/Vector.dart";

class Pixel extends Vector {
  late double intensity;

  Pixel(double x, double y) : this.withIntensity(0.0, x, y);

  Pixel.withVector(double intensity, Vector v)
      : this.withIntensity(intensity, v.x, v.y);

  Pixel.withIntensity(double intensity, double x, double y) : super(x, y) {
    this.intensity = intensity;
  }
}
