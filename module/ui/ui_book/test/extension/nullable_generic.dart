extension NullableGeneric<T> on T? {
  R? let<R>(R Function(T) applicator) {
    final self = this;
    if (self != null) {
      return applicator(self);
    }
    return null;
  }
}
