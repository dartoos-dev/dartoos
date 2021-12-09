import 'bit.dart';
import 'mask.dart';

/// Bitwise Masked **AND**.
class MAnd implements BitwiseUn {
  /// Sets the bitmask.
  const MAnd(this._mask);

  /// 8-bit Mask - the leftmost 56 bits set to '0'.
  const MAnd.w8() : this(const Mask.w8());

  /// The higher half of 8-bit words.
  const MAnd.highHalf8() : this(const Mask.highHalf8());

  /// The lower half of 8-bit words.
  const MAnd.lowHalf8() : this(const Mask.lowHalf8());

  /// 16-bit Mask - the lefmost 48 bits set to '0'.
  const MAnd.w16() : this(const Mask.w16());

  /// The higher half of 16-bit words.
  const MAnd.highHalf16() : this(const Mask.highHalf16());

  /// The lower half of 16-bit words.
  const MAnd.lowHalf16() : this(const Mask.lowHalf16());

  /// 32-bit Mask - the lefmost 32 bits set to '0'.
  const MAnd.w32() : this(const Mask.w32());

  /// The higher half of 32-bit words.
  const MAnd.highHalf32() : this(const Mask.highHalf32());

  /// The lower half of 32-bit words.
  const MAnd.lowHalf32() : this(const Mask.lowHalf32());

  /// As Dart [int] is 64-bit wide, no bits are set to '0'.
  const MAnd.w64() : this(const Mask.w64());

  /// The higher half of 64-bit words.
  const MAnd.highHalf64() : this(const Mask.highHalf64());

  /// The lower half of 64-bit words.
  const MAnd.lowHalf64() : this(const Mask.lowHalf64());

  // The bitmask.
  final Mask _mask;

  /// Convenience method; forwards to [call].
  int value(int word) => this(word);

  /// Masked value of [word].
  ///
  /// ```dart
  /// word & mask
  /// ```
  @override
  int call(int word) => word & _mask.value;
}
