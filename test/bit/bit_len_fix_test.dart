import 'package:dartoos/src/bit/fix_bit_len.dart';
import 'package:test/test.dart';

void main() {
  group('FixBitLen', () {
    const max = 0xfffffffffffffff;
    const zero = 0x00;
    test('default (64 bits)', () {
      const defBinLen = FixBitLen();
      expect(defBinLen(max), 64);
      expect(defBinLen(zero), 64);
    });
    test('8 bits', () {
      const binLen8 = FixBitLen.w8();
      expect(binLen8(max), 8);
      expect(binLen8(zero), 8);
    });
    test('16 bits', () {
      const binLen16 = FixBitLen.w16();
      expect(binLen16(max), 16);
      expect(binLen16(zero), 16);
    });
    test('32 bits', () {
      const binLen32 = FixBitLen.w32();
      expect(binLen32(max), 32);
      expect(binLen32(zero), 32);
    });
    test('64 bits', () {
      const binLen64 = FixBitLen.w64();
      expect(binLen64(max), 64);
      expect(binLen64(zero), 64);
    });
    test('1 bit', () {
      const defBinLen = FixBitLen(1);
      expect(defBinLen(max), 1);
      expect(defBinLen(zero), 1);
    });
    test('36 bits', () {
      const defBinLen = FixBitLen(36);
      expect(defBinLen(max), 36);
      expect(defBinLen(zero), 36);
    });
  });
}
