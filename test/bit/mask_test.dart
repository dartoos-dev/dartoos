import 'package:dartoos/src/bit/mask.dart';
import 'package:test/test.dart';

void main() {
  group('Mask', () {
    test('Custom value', () {
      expect(const Mask(0x77).value, 0x77);
    });
    test('Zero', () {
      expect(const Mask.zero().value, 0x00);
    });
    test('One', () {
      expect(const Mask.one().value, 1);
    });
    test('All bits set to 1', () {
      expect(const Mask.all().value, -1);
    });
    test('Lsb — Least-significant bit', () {
      expect(const Mask.lsb().value, 0x01);
    });
    test('8-bits', () {
      expect(const Mask.w8().value, 0xff);
      expect(const Mask.highHalf8().value, 0xf0);
      expect(const Mask.lowHalf8().value, 0x0f);
      expect(const Mask.msb8().value, 0x80);
    });
    test('16-bits', () {
      expect(const Mask.w16().value, 0xffff);
      expect(const Mask.highHalf16().value, 0xff00);
      expect(const Mask.lowHalf16().value, 0x00ff);
      expect(const Mask.msb16().value, 0x8000);
    });
    test('32-bits', () {
      expect(const Mask.w32().value, 0xffffffff);
      expect(const Mask.highHalf32().value, 0xffff0000);
      expect(const Mask.lowHalf32().value, 0x0000ffff);
      expect(const Mask.msb32().value, 0x80000000);
    });
    test('64-bits', () {
      expect(const Mask.w64().value, 0xffffffffffffffff);
      expect(const Mask.highHalf64().value, 0xffffffff00000000);
      expect(const Mask.lowHalf64().value, 0x00000000ffffffff);
      expect(const Mask.msb64().value, 0x8000000000000000);
    });
  });
}
