import "../Image.dart";

abstract class IInterpolator {
  bool tryGetIntensity(Image image, double x, double y, double? intensity);
  double getIntensity(Image image, double x, double y);
  String get description;
}
