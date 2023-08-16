class BaseGCode {
  String comment;

  BaseGCode(this.comment);

  @override
  String toString() {
    return comment;
  }
}
