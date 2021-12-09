import '../bit/bit.dart';
import '../bit/fix_bit_len.dart';
import '../bit/min_bit_len.dart';
import 'radix.dart';

/// The amount of hexadecimal digits to represent the value of n-bit words.
///
/// It answers the question:
///   _How many hexadecimal digits are required to represent this value?_
class HexDigLen implements DigLen {
  /// The number of hex digits to represent the value of an [n]-bit word.
  ///
  /// It defaults to compute the number of digits of 64-bit words as Dart [int]
  /// is 64-bit wide.
  const HexDigLen([BitLen bitLen = const MinBitLen()]) : _bitLen = bitLen;

  /// The number of hex digits to represent the value of a 8-bit word.
  const HexDigLen.w8() : this(const FixBitLen.w8());

  /// The number of hex digits to represent the value of a 16-bit word.
  const HexDigLen.w16() : this(const FixBitLen.w16());

  /// The number of hex digits to represent the value of a a 32-bit word.
  const HexDigLen.w32() : this(const FixBitLen.w32());

  /// The number of hex digits to represent the value of a 64-bit word.
  const HexDigLen.w64() : this(const FixBitLen.w64());

  // Something that retrieves the mininum number of bits to represent a value.
  final BitLen _bitLen;

  /// The number of digits to represent the current value of [word].
  @override
  int call(int word) => (_bitLen(word) / 4).ceil();
}
