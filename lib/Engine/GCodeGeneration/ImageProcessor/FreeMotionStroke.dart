import "dart:collection";

import "../../Geometry/Vector.dart";

class FreeMotionStroke extends LinkedListEntry<FreeMotionStroke> {
  late Vector? destinationPoint;

  FreeMotionStroke(this.destinationPoint);
}
