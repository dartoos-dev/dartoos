import 'dart:typed_data';

import 'package:dartoos/bit.dart';
import 'package:dartoos/func.dart';

/// Sets a 64-bit word into a [ByteData] according to the given endianness.
///
/// This class is useful because the method `setUint64` of [ByteData] is not
/// supported on dart2js — dart compiled into javascript.
class SetUint64 implements BiFunc<ByteData, int, int> {
  /// Big-endian
  SetUint64.big(ByteData data)
      : this._set((int offset, int word) {
          data.setUint32(offset, _highBits(word));
          data.setUint32(offset + _bytesPerWord, _lowBits(word));
          return data;
        });

  /// Little-endian
  SetUint64.little(ByteData data)
      : this._set((int offset, int w) {
          data.setUint32(offset, _lowBits(w), Endian.little);
          data.setUint32(offset + _bytesPerWord, _highBits(w), Endian.little);
          return data;
        });

  /// Host-endian
  SetUint64.host(ByteData byteData)
      : _setEndianness = Endian.host == Endian.big
            ? SetUint64.big(byteData)
            : SetUint64.little(byteData);

  /// Sets the endianess function.
  SetUint64._set(this._setEndianness);

  // The endianness function.
  ByteData Function(int offset, int word) _setEndianness;

  static const _mask32 = Mask.w32();
  static const _bytesPerWord = 4;

  static int _highBits(int word) => word >>> 32;
  static int _lowBits(int word) => word & _mask32.value;

  /// Sets the eight bytes starting at the specified [offset] to [ẃord]; returns
  /// its [ByteData] instance modified by this operation.
  ByteData value(int offset, int word) => _setEndianness(offset, word);

  /// Sets the eight bytes starting at the specified [offset] to [ẃord]; returns
  /// its [ByteData] instance modified by this operation.
  @override
  ByteData call(int offset, int word) => _setEndianness(offset, word);
}
