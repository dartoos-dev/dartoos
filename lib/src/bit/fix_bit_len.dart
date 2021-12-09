import 'bit.dart';

/// Represents a fixed bit length.
///
/// It encapsulates a value and uses it as the length of any _word_ regardless
/// of the word value.
class FixBitLen implements BitLen {
  /// As Dart [int] is 64-bit wide, the default value of [len] is 64.
  const FixBitLen([int len = 64])
      : assert(len > 0),
        _len = len;

  /// Fixed 8 bits.
  const FixBitLen.w8() : this(8);

  /// Fixed 16 bits.
  const FixBitLen.w16() : this(16);

  /// Fixed 32 bits.
  const FixBitLen.w32() : this(32);

  /// Fixed 64 bits.
  const FixBitLen.w64() : this(64);

  // The maximum width of a value in bits.
  final int _len;

  /// Returns the predefined length value.
  @override
  int call(int unused) => _len;
}
