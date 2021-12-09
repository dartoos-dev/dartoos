import 'package:dartoos/src/bit/mand.dart';
import 'package:dartoos/src/bit/rotl.dart';
import 'package:test/test.dart';

void main() {
  group('Rotl — Bitwise Left-Rotation', () {
    group('64-bit word:', () {
      const rotl64 = Rotl.w64();
      // 00001000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
      const eightBytesValue = 0x0800000000000000;
      test('wrap-around (left-shifts 64 positions)', () {
        expect(rotl64(eightBytesValue, 64), eightBytesValue);
      });
      test('up to the least-significant bit (59 positions)', () {
        expect(rotl64(eightBytesValue, 5), 1);
      });
      test('multiple by 2 (left-shifts 1 position)', () {
        const doubled = eightBytesValue * 2;
        expect(rotl64(eightBytesValue, 1), doubled);
      });
    });
    group('32-bit word:', () {
      const rotl32 = Rotl.w32();
      // 01111111 11111111 11111111 11111111 00001000 00000000 00000000 00000000
      const fourBytesValue = 0x7fffffff08000000;
      const maskedValue = fourBytesValue & 0x00000000ffffffff;
      test('wrap-around (left-shift 32 positions)', () {
        expect(rotl32(fourBytesValue, 32), maskedValue);
      });
      // up to the least-significant bit.
      test('up to the least-significant bit (27 positions)', () {
        expect(rotl32(fourBytesValue, 5), 1);
      });
      test('multiply by 2 (left-shift 1 position)', () {
        const doubled = maskedValue * 2;
        expect(rotl32(fourBytesValue, 1), doubled);
      });
    });
    group('16-bit word:', () {
      const rotl16 = Rotl.w16();
      // 01111111 11111111 11111111 11111111 11111111 11111111 00001000 00000000
      const twoBytesValue = 0x7fffffffffff0800;
      const maskedValue = twoBytesValue & 0x000000000000ffff;
      // wrap-around
      test('wrap-around (left-shift 16 positions)', () {
        expect(rotl16(twoBytesValue, 16), maskedValue);
      });
      // up to the least-significant bit.
      test('up to the least-significant bit (11 positions)', () {
        expect(rotl16(twoBytesValue, 5), 1);
      });
      test('multiply by 2 (left-shift 1 position)', () {
        const doubled = maskedValue * 2;
        expect(rotl16(twoBytesValue, 1), doubled);
      });
    });
    group('8-bit word:', () {
      const rotl8 = Rotl.w8();
      const mask8 = MAnd.w8();
      // 01111111 11111111 11111111 11111111 11111111 11111111 11111111 00001000
      const oneByteValue = 0x7fffffffffffff08;
      test('wrap-around (left-shifts 8 positions)', () {
        expect(rotl8(oneByteValue, 8), mask8(oneByteValue));
      });
      test('up to the least-significant bit (3 positions)', () {
        expect(rotl8(oneByteValue, 5), 1);
      });
      test('multiply by 2 (left-shifts 1 position)', () {
        final doubled = mask8(oneByteValue) * 2;
        expect(rotl8(oneByteValue, 1), doubled);
      });
    });
  });
}
