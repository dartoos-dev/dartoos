import 'package:dartoos/src/bit/mand.dart';
import 'package:dartoos/src/bit/rotr.dart';
import 'package:test/test.dart';

void main() {
  group('Rotr — Bitwise Right-Rotation', () {
    group('64-bit word:', () {
      const rotr64 = Rotr.w64();
      // 00001000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
      const eightBytesValue = 0x0800000000000000;
      test('wrap-around (right-shifts 64 positions)', () {
        expect(rotr64(eightBytesValue, 64), eightBytesValue);
      });
      test('up to the least-significant bit (59 positions)', () {
        expect(rotr64(eightBytesValue, 59), 1);
      });
      test('divide by 2 (right-shifts 1 position)', () {
        const half = eightBytesValue ~/ 2;
        expect(rotr64(eightBytesValue, 1), half);
      });
    });
    group('32-bit word:', () {
      const rotr32 = Rotr.w32();
      // 01111111 11111111 11111111 11111111 00001000 00000000 00000000 00000000
      const fourBytesValue = 0x7fffffff08000000;
      const maskedValue = fourBytesValue & 0x00000000ffffffff;
      test('wrap-around (right shift 32 positions)', () {
        expect(rotr32(fourBytesValue, 32), maskedValue);
      });
      // up to the least-significant bit.
      test('up to the least-significant bit (27 positions)', () {
        expect(rotr32(fourBytesValue, 27), 1);
      });
      test('divide by 2 (right shift 1 position)', () {
        const half = maskedValue ~/ 2;
        expect(rotr32(fourBytesValue, 1), half);
      });
    });
    group('16-bit word:', () {
      const rotr16 = Rotr.w16();
      // 01111111 11111111 11111111 11111111 11111111 11111111 00001000 00000000
      const twoBytesValue = 0x7fffffffffff0800;
      const maskedValue = twoBytesValue & 0x000000000000ffff;
      // wrap-around
      test('wrap-around (right shift 16 positions)', () {
        expect(rotr16(twoBytesValue, 16), maskedValue);
      });
      // up to the least-significant bit.
      test('up to the least-significant bit (11 positions)', () {
        expect(rotr16(twoBytesValue, 11), 1);
      });
      test('divide by 2 (right shift 1 position)', () {
        const half = maskedValue ~/ 2;
        expect(rotr16(twoBytesValue, 1), half);
      });
    });
    group('8-bit word:', () {
      // 01111111 11111111 11111111 11111111 11111111 11111111 11111111 00001000
      const rotr8 = Rotr.w8();
      const oneByteValue = 0x7fffffffffffff08;
      const mask8 = MAnd.w8();
      test('wrap-around (right-shifts 8 positions)', () {
        expect(rotr8(oneByteValue, 8), mask8(oneByteValue));
      });
      test('up to the least-significant bit (3 positions)', () {
        expect(rotr8(oneByteValue, 3), 1);
      });
      test('divide by 2 (right-shifts 1 position)', () {
        final half = mask8(oneByteValue) ~/ 2;
        expect(rotr8(oneByteValue, 1), half);
      });
    });
  });
}
