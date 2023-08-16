class PathTypeHelper {
  static bool isSet(int pthType, int flag) {
    if (flag == 0) {
      return pthType == 0;
    }
    return (pthType & flag) == flag;
  }
}
