import 'package:dartoos/src/bit/mask.dart';
import 'package:dartoos/src/bit/mor.dart';
import 'package:test/test.dart';

void main() {
  group('MOr — Masked Bitwise "OR" Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    test('custom mask', () {
      const cmask = 0xaaaaaaaaaaaaaaaa;
      const mor = MOr(Mask(cmask));
      expect(mor(zeroes), cmask);
      expect(mor(ones), ones);
    });
    test('8-bit mask', () {
      const mor8 = MOr.w8();
      expect(mor8(zeroes), 0xff);
      expect(mor8(ones), ones);
    });
    test('16-bit mask', () {
      const mor16 = MOr.w16();
      expect(mor16(zeroes), 0xffff);
      expect(mor16(ones), ones);
    });
    test('32-bit mask', () {
      const mor32 = MOr.w32();
      expect(mor32(zeroes), 0xffffffff);
      expect(mor32(ones), ones);
    });
    test('64-bit mask', () {
      const mor64 = MOr.w64();
      expect(mor64(zeroes), 0xffffffffffffffff);
      expect(mor64(ones), ones);
    });
  });
}
