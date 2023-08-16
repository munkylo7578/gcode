import "../GCodeGeneration/BaseGCode.dart";
import "../Geometry/Vector.dart";
import 'package:intl/intl.dart';
import 'dart:math';

abstract class BaseMotion extends BaseGCode {
  Vector? position;

  BaseMotion(this.position) : super('');

  String doubleToStr(double? value) {
    final formatter = NumberFormat("0.###", "en_US");
    return formatter.format(value);
  }
}
