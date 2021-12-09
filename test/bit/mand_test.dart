import 'package:dartoos/src/bit/mand.dart';
import 'package:dartoos/src/bit/mask.dart';
import 'package:test/test.dart';

void main() {
  group('MAND — Masked Bitwise "AND" Operation', () {
    test('custom mask', () {
      const ones = 0xFFFFFFFFFFFFFFFF;
      const zeroes = 0x000000000000000;
      const cmask = 0xaaaaaaaaaaaaaaaa;
      const mand = MAnd(Mask(cmask));
      expect(mand(zeroes), zeroes);
      expect(mand(ones), cmask);
    });
    test('8-bit mask', () {
      const ones = 0xff;
      const highHalf = 0xf0;
      const lowHalf = 0x0f;
      const zeroes = 0x00;
      const mand8 = MAnd.w8();
      expect(mand8(zeroes), 0);
      expect(mand8(ones), ones);
      expect(const MAnd.highHalf8().value(ones), highHalf);
      expect(const MAnd.lowHalf8().value(ones), lowHalf);
    });
    test('16-bit mask', () {
      const ones = 0xffff;
      const highHalf = 0xff00;
      const lowHalf = 0x00ff;
      const zeroes = 0x0000;
      const mand16 = MAnd.w16();
      expect(mand16(zeroes), 0);
      expect(mand16(ones), ones);
      expect(const MAnd.highHalf16().value(ones), highHalf);
      expect(const MAnd.lowHalf16().value(ones), lowHalf);
    });
    test('32-bit mask', () {
      const ones = 0xffffffff;
      const highHalf = 0xffff0000;
      const lowHalf = 0x0000ffff;
      const zeroes = 0x00000000;
      const mand32 = MAnd.w32();
      expect(mand32(zeroes), 0);
      expect(mand32(ones), ones);
      expect(const MAnd.highHalf32().value(ones), highHalf);
      expect(const MAnd.lowHalf32().value(ones), lowHalf);
    });
    test('64-bit mask', () {
      const ones = 0xffffffffffffffff;
      const highHalf = 0xffffffff00000000;
      const lowHalf = 0x00000000ffffffff;
      const zeroes = 0x0000000000000000;
      const mand64 = MAnd.w64();
      expect(mand64(zeroes), 0);
      expect(mand64(ones), ones);
      expect(const MAnd.highHalf64().value(ones), highHalf);
      expect(const MAnd.lowHalf64().value(ones), lowHalf);
    });
  });
}
