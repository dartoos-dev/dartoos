import 'package:dartoos/bit.dart';
// import 'mask.dart';
// import 'nop.dart';

/// Bitwise Right-Rotation Operation.
class Rotr implements BitwiseBi {
  /// Right-rotates [len]-bit _words_.
  ///
  /// [len] must be > 0, and [mask] must have its rightmost [len] bits set to
  /// _1_; e.g., len = 8 => mask = 0xff (00…011111111₂).
  const Rotr(int len, Mask mask)
      : assert(len > 0),
        _len = len,
        _mask = mask;

  /// Right-rotates 8-bit words.
  // const Rotr.w8() : this(8, 0xff);
  const Rotr.w8() : this(8, const Mask.w8());

  /// Right-rotates 16-bit words.
  const Rotr.w16() : this(16, const Mask.w16());

  /// Right-rotates 32-bit words.
  const Rotr.w32() : this(32, const Mask.w32());

  /// Right-rotates 64-bit words.
  const Rotr.w64() : this(64, const Mask.w64());

  // The number of bits.
  final int _len;
  // The bitmask operation.
  final Mask _mask;

  /// Right-rotates the bit pattern in [word] by [n] positions.
  @override
  int call(int word, int n) {
    final w = word & _mask.value;
    return (w >>> n) | ((w << (_len - n)) & _mask.value);
  }
}
