import 'package:dartoos/src/bit/min_bit_len.dart';
import 'package:test/test.dart';

void main() {
  group('MinBitLen', () {
    test('From 1 up to 8 bits wide', () {
      // Values up to 8 bits wide.
      const upTo8Bits = <int>[
        -1, // A placeholder value that should be skipped.
        0x00, // 1 bit
        0x03, // 2 bits
        0x07, // 3 bits
        0x0f, // 4 bits
        0x10, // 5 bits
        0x30, // 6 bits
        0x70, // 7 bits
        0xf0, // 8 bits
      ];
      const bitLen8 = MinBitLen.w8();
      for (int i = 1; i < upTo8Bits.length; ++i) {
        final value = upTo8Bits[i];
        expect(bitLen8(value), i);
      }
    });
    test('From 1  up to 16 bits wide', () {
      // Values up to 16 bits wide.
      const upTo16Bits = <int>[
        -1, // A placeholder value that should be skipped.
        0x00, // 1
        0x03, // 2
        0x07, // 3
        0x0f, // 4
        0x10, // 5
        0x30, // 6
        0x70, // 7
        0xf0, // 8
        0x100, // 9
        0x300, // 10
        0x700, // 11
        0xf00, // 12
        0x1000, // 13
        0x3000, // 14
        0x7000, // 15
        0xf000, // 16
      ];
      const bitLen16 = MinBitLen.w16();
      for (int i = 1; i < upTo16Bits.length; ++i) {
        final value = upTo16Bits[i];
        expect(bitLen16(value), i);
      }
    });
    test('From one up to 32 bits wide', () {
      // Values up to 16 bits wide.
      const upTo32Bits = <int>[
        -1, // A placeholder value that should be skipped.
        0x00, // 1
        0x03, // 2
        0x07, // 3
        0x0f, // 4
        0x10, // 5
        0x30, // 6
        0x70, // 7
        0xf0, // 8
        0x100, // 9
        0x300, // 10
        0x700, // 11
        0xf00, // 12
        0x1000, // 13
        0x3000, // 14
        0x7000, // 15
        0xf000, // 16
        0x10000, // 17
        0x30000, // 18
        0x70000, // 19
        0xf0000, // 20
        0x100000, // 21
        0x300000, // 22
        0x700000, // 23
        0xf00000, // 24
        0x1000000, // 25
        0x3000000, // 26
        0x7000000, // 27
        0xf000000, // 28
        0x10000000, // 29
        0x30000000, // 30
        0x70000000, // 31
        0xf0000000, // 32
      ];
      const binLen32 = MinBitLen.w32();
      for (int i = 1; i < upTo32Bits.length; ++i) {
        final value = upTo32Bits[i];
        expect(binLen32(value), i);
      }
    });

    test('From 1 up to 64 bits wide', () {
      // Values up to 64 bits wide.
      const upTo64Bits = <int>[
        -1, // A placeholder value that should be skipped.
        0x00, // 1
        0x03, // 2
        0x07, // 3
        0x0f, // 4
        0x10, // 5
        0x30, // 6
        0x70, // 7
        0xf0, // 8
        0x100, // 9
        0x300, // 10
        0x700, // 11
        0xf00, // 12
        0x1000, // 13
        0x3000, // 14
        0x7000, // 15
        0xf000, // 16
        0x10000, // 17
        0x30000, // 18
        0x70000, // 19
        0xf0000, // 20
        0x100000, // 21
        0x300000, // 22
        0x700000, // 23
        0xf00000, // 24
        0x1000000, // 25
        0x3000000, // 26
        0x7000000, // 27
        0xf000000, // 28
        0x10000000, // 29
        0x30000000, // 30
        0x70000000, // 31
        0xf0000000, // 32
        0x100000000, // 33
        0x300000000, // 34
        0x700000000, // 35
        0xf00000000, // 36
      ];
      const bitLen64 = MinBitLen.w64();
      for (int i = 1; i < upTo64Bits.length; ++i) {
        final value = upTo64Bits[i];
        expect(bitLen64(value), i);
      }
    });
  });
}
