import 'package:dartoos/src/bit/add.dart';
import 'package:test/test.dart';

void main() {
  group('Addition Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    test('Default overflow semantics', () {
      const add = Add();
      // overflow
      expect(add(ones, 1), 0);
      expect(add(0, -1), ones);

      expect(add(zeroes, zeroes), zeroes);
      expect(add(zeroes, ones), ones);
      expect(add(ones, zeroes), ones);
      expect(add(0xaaaa, 0x4444), 0xeeee);
    });
    test('8 bits overflow semantics', () {
      const add8 = Add.w8();
      // 8 bits set to '1'
      const ones8 = 0xff;
      // overflow
      expect(add8(ones8, 1), 0);
      expect(add8(0, -1), ones8);

      expect(add8(zeroes, zeroes), zeroes);
      expect(add8(zeroes, ones), 0xff);
      expect(add8(ones, zeroes), 0xff);
      expect(add8(0xaaaa, 0x4444), 0xee);
    });
    test('16 bits overflow semantics', () {
      const add16 = Add.w16();
      // 16 bits set to 1.
      const ones16 = 0xffff;

      // overflow
      expect(add16(ones16, 1), 0);
      expect(add16(0, -1), ones16);

      expect(add16(zeroes, zeroes), zeroes);
      expect(add16(zeroes, ones), 0xffff);
      expect(add16(ones, zeroes), 0xffff);
      expect(add16(0xaaaaaaaa, 0x44444444), 0xeeee);
    });
    test('32 bits overflow semantics', () {
      const add32 = Add.w32();
      // 32 bits set to 1.
      const ones32 = 0xffffffff;
      // overflow
      expect(add32(ones32, 1), 0);
      expect(add32(0, -1), ones32);

      expect(add32(zeroes, zeroes), zeroes);
      expect(add32(zeroes, ones), 0xffffffff);
      expect(add32(ones, zeroes), 0xffffffff);
      expect(add32(0xaaaaaaaaaaaaaaaa, 0x4444444444444444), 0xeeeeeeee);
    });
    test('64 bits overflow semantics', () {
      const add64 = Add.w64();
      // overflow
      expect(add64(ones, 1), 0);
      expect(add64(0, -1), ones);

      expect(add64(zeroes, zeroes), zeroes);
      expect(add64(zeroes, ones), 0xffffffffffffffff);
      expect(add64(ones, zeroes), 0xffffffffffffffff);
      expect(add64(0xaaaaaaaaaaaaaaaa, 0x4444444444444444), 0xeeeeeeeeeeeeeeee);
    });
  });
}
