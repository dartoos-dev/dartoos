import 'package:dartoos/src/bit/nshl.dart';
import 'package:test/test.dart';

void main() {
  group('NShl — Bitwise Left-Shift', () {
    test('0 positions', () {
      const shift0 = NShl(0);
      expect(shift0(99), 99);
      expect(shift0(1), 1);
    });
    test('2 positions', () {
      const shift2 = NShl(2);
      expect(shift2(2), 8);
      expect(shift2(23), 92);
    });
    test('1000 positions', () {
      const shift1000 = NShl(1000);
      expect(shift1000(99), 0);
      expect(shift1000(1000), 0);
    });
    test('negative position', () {
      expect(() => NShl(-1), throwsA(isA<AssertionError>()));
    });
  });
}
