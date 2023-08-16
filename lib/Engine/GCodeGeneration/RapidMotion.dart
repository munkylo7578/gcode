import "../GCodeGeneration/BaseMotion.dart";
import "../Geometry/Vector.dart";
import 'package:sprintf/sprintf.dart';

class RapidMotion extends BaseMotion {
  static const String GCODE_FORMAT = 'G0 X%s Y%s S0';
  static const String GCODE_FORMAT_COMMENT = 'G0 X%s Y%s S0; %s';

  RapidMotion(Vector? position) : super(position);

  RapidMotion.withComment(Vector position, String comment) : super(position) {
    this.comment = comment;
  }

  @override
  String toString() {
    if (comment != null && comment.isNotEmpty) {
      return sprintf(GCODE_FORMAT_COMMENT,
          [doubleToStr(position?.x), doubleToStr(position?.y), comment]);
    }
    return sprintf(
        GCODE_FORMAT, [doubleToStr(position?.x), doubleToStr(position?.y)]);
  }
}
