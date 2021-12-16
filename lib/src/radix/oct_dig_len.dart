import 'package:dartoos/bit.dart';
import 'package:dartoos/radix.dart';

/// The amount of octal digits to represent the value of n-bit words.
///
/// It answers the question:
///   _How many octal digits are required to represent this value?_
class OctDigLen implements DigLen {
  /// The number of octal digits to represent the value of an [n]-bit word.
  ///
  /// It defaults to compute the number of digits of 64-bit words as Dart [int]
  /// is 64-bit wide.
  const OctDigLen([BitLen bitLen = const MinBitLen()]) : _bitLen = bitLen;

  /// The number of octal digits to represent the value of a 8-bit word.
  const OctDigLen.w8() : this(const FixBitLen.w8());

  /// The number of octal digits to represent the value of a 16-bit word.
  const OctDigLen.w16() : this(const FixBitLen.w16());

  /// The number of octal digits to represent the value of a a 32-bit word.
  const OctDigLen.w32() : this(const FixBitLen.w32());

  /// The number of octal digits to represent the value of a 64-bit word.
  const OctDigLen.w64() : this(const FixBitLen.w64());

  // Something that retrieves the mininum number of bits to represent a value.
  final BitLen _bitLen;

  /// The number of octal digits to represent the current value of [word].
  @override
  int call(int word) => (_bitLen(word) / 3).ceil();
}
