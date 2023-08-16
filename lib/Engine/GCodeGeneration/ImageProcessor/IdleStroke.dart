import 'dart:math';
import "./Stroke.dart";
import '../../Geometry/Vector.dart';

class IdleStroke extends Stroke {
  IdleStroke(Vector? destination) : super(destination, 0);
}
