import 'package:dartoos/src/bit/sub.dart';
import 'package:test/test.dart';

void main() {
  group('Subtraction Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    test('Default overflow semantics', () {
      const sub = Sub();
      expect(sub.value(zeroes, zeroes), zeroes);
      expect(sub(ones, zeroes), ones);
      expect(sub(0, 1), ones); // -1
      expect(sub(0xaaaa, 0x4444), 0x6666);
      expect(sub(0, -1), 1);
    });
    test('8 bits overflow semantics', () {
      const sub8 = Sub.w8();
      // 8 bits set to '1'
      const ones8 = 0xff;
      // overflow
      expect(sub8.value(ones8, 1), 0xfe);
      expect(sub8(0, -1), 1);

      expect(sub8.value(zeroes, zeroes), zeroes);
      expect(sub8(zeroes, ones), 1);
      expect(sub8(ones, zeroes), 0xff);
      expect(sub8(0xaaaa, 0x4444), 0x66);
    });
    test('16 bits overflow semantics', () {
      const sub16 = Sub.w16();
      // 16 bits set to 1.
      const ones16 = 0xffff;

      // overflow
      expect(sub16.value(ones16, 1), 0xfffe);
      expect(sub16(0, -1), 1);

      expect(sub16(zeroes, zeroes), zeroes);
      expect(sub16(zeroes, ones), 1);
      expect(sub16(ones, zeroes), 0xffff);
      expect(sub16(0xaaaaaaaa, 0x44444444), 0x6666);
    });
    test('32 bits overflow semantics', () {
      const sub32 = Sub.w32();
      // 32 bits set to 1.
      const ones32 = 0xffffffff;
      // overflow
      expect(sub32.value(ones32, 1), 0xfffffffe);
      expect(sub32(0, -1), 1);

      expect(sub32.value(zeroes, zeroes), zeroes);
      expect(sub32(zeroes, ones), 1);
      expect(sub32(ones, zeroes), 0xffffffff);
      expect(sub32(0xaaaaaaaaaaaaaaaa, 0x4444444444444444), 0x66666666);
    });
    test('64 bits overflow semantics', () {
      const sub64 = Sub.w64();
      // overflow
      expect(sub64.value(ones, 1), 0xfffffffffffffffe);
      expect(sub64(0, -1), 1);

      expect(sub64.value(zeroes, zeroes), zeroes);
      expect(sub64(zeroes, ones), 1);
      expect(sub64(ones, zeroes), 0xffffffffffffffff);
      expect(sub64(0xaaaaaaaaaaaaaaaa, 0x4444444444444444), 0x6666666666666666);
    });
  });
}
