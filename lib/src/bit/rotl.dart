import 'package:dartoos/bit.dart';

/// Bitwise Left-Rotation Operation.
class Rotl implements BitwiseBi {
  /// Left-rotates [len]-bit _words_.
  ///
  /// [len] must be > 0, and [mask] must have its rightmost [len] bits set to
  /// _1_; e.g., len = 8 => mask = 0xff (00…011111111₂).
  const Rotl(int len, Mask mask)
      : assert(len > 0),
        _len = len,
        _mask = mask;

  /// Left-rotates 64-bit words.
  const Rotl.w64() : this(64, const Mask.w64());

  /// Left-rotates 32-bit words.
  const Rotl.w32() : this(32, const Mask.w32());

  /// Left-rotates 16-bit words.
  const Rotl.w16() : this(16, const Mask.w16());

  /// Left-rotates 8-bit words.
  const Rotl.w8() : this(8, const Mask.w8());

  // The number of bits.
  final int _len;

  // The bitmask
  final Mask _mask;

  /// Left-rotates the bit pattern in [word] by [n] positions.
  @override
  int call(int word, int n) {
    final w = word & _mask.value;
    return ((w << n) & _mask.value) | (w >>> (_len - n));
  }
}
