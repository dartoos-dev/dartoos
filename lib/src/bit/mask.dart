import 'bit.dart';

/// A bitmask.
///
/// It contains a set of convenience constructors for the most common bitmasks.
class Mask implements Bits {
  /// A n-bit mask.
  const Mask(this.value);

  /// All bits set to '0'.
  ///
  /// _00000000000000000000000000000000000000000000000000000000000000_
  const Mask.zero() : this(0x00);

  /// Only the righmost bit set to '1'.
  ///
  /// It is equivalent to [Mask.lsb].
  ///
  ///   _…00000001_
  const Mask.one() : this.lsb();

  /// All bits set to '1'.
  ///
  /// As Dart [int] is 64-bit wide, it is equivalent to [Mask.w64].
  ///
  ///   _1111111111111111111111111111111111111111111111111111111111111111_
  const Mask.all() : this(-1);

  /// The least-significant bit set to '1'.
  ///
  ///   _…00000001_
  const Mask.lsb() : this(0x01);

  /// A 8-bit mask.
  ///
  /// The least-significant byte set to '1'.
  ///
  ///   _11111111_
  const Mask.w8() : this(0xff);

  /// The most-significant bit of an 8-bit word.
  ///
  ///   _10000000_
  const Mask.msb8() : this(0x80);

  /// The higher 4-bits (nibble) of an 8-bit word,
  ///
  ///   _11110000_.
  const Mask.highHalf8() : this(0xf0);

  /// The lower 4-bits (nibble) of an 8-bit word.
  ///
  ///   _00001111_
  const Mask.lowHalf8() : this(0x0f);

  /// A 16-bit mask.
  ///
  ///   _1111111111111111_
  const Mask.w16() : this(0xffff);

  /// The most-significant bit of a 16-bit word.
  ///
  ///   _1000000000000000_
  const Mask.msb16() : this(0x8000);

  /// The higher 8-bits (byte) of a 16-bit word.
  ///
  ///   _1111111100000000_
  const Mask.highHalf16() : this(0xff00);

  /// The lower 8-bits (byte) of an 16-bit word.
  ///
  ///   _0000000011111111_
  const Mask.lowHalf16() : this.w8();

  /// A 32-bit mask.
  ///
  ///   _11111111111111111111111111111111_
  const Mask.w32() : this(0xffffffff);

  /// The most-significant bit of a 32-bit word.
  ///
  ///   _10000000000000000000000000000000_
  const Mask.msb32() : this(0x80000000);

  /// The higher 16-bits (2-bytes) of a 32-bit word.
  ///
  ///   _11111111111111110000000000000000_.
  const Mask.highHalf32() : this(0xffff0000);

  /// The lower 16-bits (2-bytes) of a 32-bit word.
  ///
  ///   _00000000000000001111111111111111_
  const Mask.lowHalf32() : this.w16();

  /// A 64-bit mask.
  ///
  ///   _1111111111111111111111111111111111111111111111111111111111111111_
  const Mask.w64() : this(0xffffffffffffffff);

  /// The most-significant bit of a 64-bit word.
  ///
  ///   _1000000000000000000000000000000000000000000000000000000000000000_
  const Mask.msb64() : this(0x8000000000000000);

  /// The higher 32-bits of a 64-bit word.
  ///
  ///   _1111111111111111111111111111111100000000000000000000000000000000_
  const Mask.highHalf64() : this(0xffffffff00000000);

  /// The lower 32-bits of a 64-bit word.
  ///
  ///   _0000000000000000000000000000000011111111111111111111111111111111_
  const Mask.lowHalf64() : this.w32();

  /// The bitmask value.
  final int value;

  /// The bitmask value.
  @override
  int call() => value;
}
