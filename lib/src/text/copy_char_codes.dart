/// Callable helper class that copies character codes from a source [String] into
/// a destination List<int>.
class CopyCharCodes {
  /// [dest] the destination of character codes.
  CopyCharCodes(List<int> dest, [int start = 0])
      : _dest = dest,
        _ind = start;
  // the destination of char codes.
  final List<int> _dest;
  // the index to keep track.
  int _ind;

  /// Checks whether the destination list is not full.
  bool get isNotFull => _ind < _dest.length;

  /// [src] the source of character codes to copy from.
  void call(String src) {
    for (var i = 0; i < src.length; ++i) {
      _dest[_ind++] = src.codeUnitAt(i);
    }
  }
}
