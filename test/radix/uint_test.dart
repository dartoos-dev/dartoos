import 'package:dartoos/src/radix/uint.dart';
import 'package:test/test.dart';

void main() {
  group('UintOf', () {
    test('Single byte', () {
      // generates Uint values from 0 to 255.
      final values = List<int>.generate(255, (int i) => i);
      const plain = Uint.noPad();
      const padded = Uint.w8();
      for (final byte in values) {
        expect(plain(byte), byte.toRadixString(10));
        expect(padded(byte), byte.toRadixString(10).padLeft(3, '0'));
      }
    });
    test('8-bits word', () {
      const uint8 = Uint.w8();
      expect(uint8(0), '000');
      expect(uint8(9), '009');
      expect(uint8(10), '010');
      expect(uint8(32), '032');
      expect(uint8(99), '099');
      expect(uint8(100), '100');
      expect(uint8(201), '201');
      expect(uint8(255), '255');
    });
    test('16-bits word', () {
      const uint16 = Uint.w16();
      expect(uint16(0), '00000');
      expect(uint16(1234), '01234');
      expect(uint16(4444), '04444');
      expect(uint16(99999), '99999');
      expect(uint16(10000), '10000');
      expect(uint16(65535), '65535');
    });
    test('32-bits word', () {
      const uint32 = Uint.w32();
      expect(uint32(0), '0000000000');
      expect(uint32(12341234), '0012341234');
      expect(uint32(999999999), '0999999999');
      expect(uint32(1000000000), '1000000000');
      expect(uint32(4294967295), '4294967295');
    });
    test('64-bits word', () {
      const uint64 = Uint.w64();
      expect(uint64(0), '0000000000000000000');
      expect(uint64(9), '0000000000000000009');
      expect(uint64(10), '0000000000000000010');
      expect(uint64(1234123412341234), '0001234123412341234');
      expect(uint64(999999999999999999), '0999999999999999999');
      expect(uint64(9223372036854775807), '9223372036854775807');
    });
  });
}
