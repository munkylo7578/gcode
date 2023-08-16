import 'dart:math';

import './Vector.dart';

class Bezier {
  static const double INTERPOLATOR_STEP_MM = 2;

  late Vector start;
  late Vector end;
  late Vector pStart;
  late Vector pEnd;

  Bezier(this.start, this.end, this.pStart, this.pEnd);

  Iterable<Vector> getInterpolatedPoints() sync* {
    int steps = getIteratorSteps();

    if (steps == 0) {
      yield getPoint(0.0);
      yield getPoint(0.5);
      yield getPoint(1.0);
    } else {
      for (int i = 0; i <= steps; i++) {
        yield getPoint(1.0 / steps * i);
      }
    }
  }

  Vector getPoint(double pos) {
    double pos1 = 1 - pos;
    double pos13 = pos1 * pos1 * pos1;
    double pos3 = pos * pos * pos;

    double x = pos13 * start.x +
        3 * pos * pos1 * pos1 * pStart.x +
        3 * pos * pos * pos1 * pEnd.x +
        pos3 * end.x;
    double y = pos13 * start.y +
        3 * pos * pos1 * pos1 * pStart.y +
        3 * pos * pos * pos1 * pEnd.y +
        pos3 * end.y;
    return Vector(x, y);
  }

  int getIteratorSteps() {
    double len = (Vector.getLength(start, pStart) +
            Vector.getLength(pStart, pEnd) +
            Vector.getLength(pEnd, end)) *
        0.75;
    return (len / INTERPOLATOR_STEP_MM).floor();
  }
}
