import 'bit.dart';
import 'mask.dart';

/// The minimum amount of bits required to represent the value of an _[n]-bit
/// words_.
///
/// Typically, the number of bits ranges from 1 up to 64.
///
/// Examples of the relationship between integer values and the minimum amount
/// of bits to represent it:
///
/// - the value 0 requires at least 1 bit to be represented.
/// - the decimal value 15 (1111₂) requires at least 4 bits to be represented.
/// - the value 1000 (a thousand) requires at least 10 bits to be represented.
/// - negative values require 64 bits — due to the two's complement system.
class MinBitLen implements BitLen {
  /// The minimum number of bits to represent the value of an _[n]-bit word_.
  ///
  /// [n] defaults to 64 (as [int] is 64-bit wide); it must be > 0.
  ///
  /// [msb] is the bitmask for the most-signifcant bit of a [n]-bit word.
  const MinBitLen({int n = 64, Mask msb = const Mask.msb64()})
      : assert(n > 0),
        _n = n,
        _msb = msb;

  /// The minimum number of bits to represent the value of a 8-bit word.
  const MinBitLen.w8() : this(n: 8, msb: const Mask.msb8());

  /// The minimum number of bits to represent the value of a 16-bit word.
  const MinBitLen.w16() : this(n: 16, msb: const Mask.msb16());

  /// The minimum number of bits to represent the value of a 32-bit word.
  const MinBitLen.w32() : this(n: 32, msb: const Mask.msb32());

  /// The minimum number of bits to represent the value of a 64-bit word.
  const MinBitLen.w64() : this(n: 64, msb: const Mask.msb64());

  // The maximum width of a n-bit word.
  final int _n;
  // A bitmask for the most-signifcant bit.
  final Mask _msb;

  @override
  int call(int word) {
    // the most-signifcant bit.
    var msb = _msb.value;
    var numOfBits = _n;
    while (((word & msb) == 0) && (numOfBits > 1)) {
      msb >>= 1;
      --numOfBits;
    }
    return numOfBits;
  }
}
