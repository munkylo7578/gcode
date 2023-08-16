import 'package:flutter/material.dart';
import '../GCodeGeneration/BaseMotion.dart';
import '../Geometry/Vector.dart';
import 'package:intl/intl.dart';

class CoordinateMotion extends BaseMotion {
  static const String GCODE_FORMAT = 'G1X{0}Y{1}F{2}S{3}';
  static const String GCODE_FORMAT_COMMENT = 'G1X{0}Y{1}F{2}S{3};{4}';

  late int intensity;
  late int feed;
  late Color color;

  CoordinateMotion(Vector? position, int intensity, int feed, Color color)
      : super(position) {
    this.intensity = intensity;
    this.feed = feed;
    this.color = color;
  }

  CoordinateMotion.withDefaultColor(Vector position, int intensity, int feed)
      : this(position, intensity, feed, Colors.black);

  @override
  String toString() {
    final formatter = NumberFormat();
    if (comment != null && comment.isNotEmpty) {
      return GCODE_FORMAT_COMMENT.replaceAllMapped(RegExp(r'\{(\d+)\}'),
          (match) {
        final index = int.parse(match.group(1)!);
        switch (index) {
          case 0:
            return formatter.format(position?.x);
          case 1:
            return formatter.format(position?.y);
          case 2:
            return feed.toString();
          case 3:
            return intensity.toString();
          case 4:
            return comment!;
          default:
            return match.group(0)!;
        }
      });
    }
    return GCODE_FORMAT.replaceAllMapped(RegExp(r'\{(\d+)\}'), (match) {
      final index = int.parse(match.group(1)!);
      switch (index) {
        case 0:
          return formatter.format(position?.x);
        case 1:
          return formatter.format(position?.y);
        case 2:
          return feed.toString();
        case 3:
          return intensity.toString();
        default:
          return match.group(0)!;
      }
    });
  }
}
