import 'dart:typed_data';

import 'package:dartoos/src/bit/set_uint64.dart';
import 'package:test/test.dart';

void main() {
  group('SetUint64', () {
    const highHalf = 0xffffffff00000000;
    const lowHalf = 0x00000000ffffffff;

    final asHost = SetUint64.host(ByteData(8));
    final asBig = SetUint64.big(ByteData(8));
    final asLittle = SetUint64.little(ByteData(8));
    test('the result length in bytes', () {
      expect(asLittle(0, 0x0000000000000000).lengthInBytes, 8);
      expect(asLittle(0, 0xaaaaaaaaaaaaaaaa).lengthInBytes, 8);
      expect(asBig(0, 0x88888).lengthInBytes, 8);
      expect(asBig(0, 0xffffffffffffffff).lengthInBytes, 8);
      expect(asHost(0, 0x1122334455667788).lengthInBytes, 8);
    });
    test('Little-endian', () {
      final forward = asLittle(0, highHalf).getUint64(0, Endian.little);
      expect(forward, highHalf);
      final backwards = asLittle(0, highHalf).getUint64(0);
      expect(backwards, lowHalf);
    });
    test('Big-endian', () {
      final forward = asBig(0, highHalf).getUint64(0);
      expect(forward, highHalf);
      final backwards = asBig(0, highHalf).getUint64(0, Endian.little);
      expect(backwards, lowHalf);
    });
    test('Host-endian', () {
      final mustBeHighHalf = asHost(0, highHalf).getUint64(0, Endian.host);
      expect(mustBeHighHalf, highHalf);
      final mustBeLowHalf = asHost(0, lowHalf).getUint64(0, Endian.host);
      expect(mustBeLowHalf, lowHalf);
    });
  });
}
