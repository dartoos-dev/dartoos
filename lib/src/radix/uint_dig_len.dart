import 'package:dartoos/bit.dart';
import 'package:dartoos/radix.dart';

/// The amount of unsigned integer digits to represent an n-bit word.
///
/// It answers the question:
///   _How many decimal digits are required to represent this value?_
class UintDigLen implements DigLen {
  /// The number of decimal digits to represent the value of an [n]-bit word.
  ///
  /// It defaults to compute the number of digits of 64-bit words as Dart [int]
  /// is 64-bit wide.
  const UintDigLen([BitLen bitLen = const MinBitLen()]) : _bitLen = bitLen;

  /// The number of digits to represent the value of a 8-bit word.
  const UintDigLen.w8() : this(const FixBitLen.w8());

  /// The number of digits to represent the value of a 16-bit word.
  const UintDigLen.w16() : this(const FixBitLen.w16());

  /// The number of digits to represent the value of a a 32-bit word.
  const UintDigLen.w32() : this(const FixBitLen.w32());

  /// The number of digits to represent the value of a 64-bit word.
  const UintDigLen.w64() : this(const FixBitLen.w64());

  // Something that retrieves the mininum number of bits to represent a value.
  final BitLen _bitLen;

  /// The number of digits to represent the current value of [word].
  @override
  int call(int word) {
    // Due to the two's complement, negative values always have the most
    // significant bit set to '1'; therefore, they are represented using the
    // maximum number of digits.
    if (word < 0) return _maxDigIn64Bits;
    // theoretical maximum number os digits.
    final calcDigits = (_bitLen(word) / _log10base2).ceil();
    // avoids [RangeError] in case of calcDigits > 20.
    final maxDigits =
        calcDigits > _maxDigIn64Bits ? _maxDigIn64Bits : calcDigits;
    final minDigits = maxDigits - 1;
    final minValue = _largestByDigits[minDigits];
    // if word turns out to be greater than minValue, the number of digits to
    // represent it is definitely maxDigits.
    return word > minValue ? maxDigits : minDigits;
  }

  static const _maxDigIn64Bits = 19;
  static const _log10base2 = 3.321928095;
  static const _largestIntIn64Bits = 9223372036854775807;
  static const _smallestIntIn64Bits = -9223372036854775808;
  // the largest integers by number of digits.
  static const _largestByDigits = [
    _smallestIntIn64Bits, // index 0
    9, // 1 '9' is the largest one-digit number.
    99, // 2 '99' is the largest two-digit number.
    999, // 3 …
    9999, // 4
    99999, // 5
    999999, // 6
    9999999, // 7
    99999999, // 8
    999999999, // 9
    9999999999, // 10
    99999999999, // 11
    999999999999, // 12
    9999999999999, // 13
    99999999999999, // 14
    999999999999999, // 15
    9999999999999999, // 16
    99999999999999999, // 17
    999999999999999999, // 18
    _largestIntIn64Bits, // 19
  ];
}
