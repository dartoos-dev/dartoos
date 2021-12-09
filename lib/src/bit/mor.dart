import 'bit.dart';
import 'mask.dart';

/// Bitwise Masked **OR**.
class MOr implements BitwiseUn {
  /// Sets the bitmask.
  const MOr(this._mask);

  /// 8-bit Or-Mask - the rightmost 8 bits set to '1'.
  const MOr.w8() : this(const Mask.w8());

  /// 16-bit Or-Mask - the rightmost 16 bits set to '1'.
  const MOr.w16() : this(const Mask.w16());

  /// 32-bit Or-Mask - the rightmost 32 bits set to '1'.
  const MOr.w32() : this(const Mask.w32());

  /// 64-bit Or-Mask - as Dart [int] is 64-bit wide, all bits are set to '1'.
  const MOr.w64() : this(const Mask.w64());

  // The bitmask.
  final Mask _mask;

  /// 'Or' masked value of [word].
  ///
  /// ```dart
  /// word | mask
  /// ```
  int value(int word) => word | _mask.value;

  /// 'Or' masked value of [word].
  ///
  /// ```dart
  /// word | mask
  /// ```
  @override
  int call(int word) => value(word);
}
