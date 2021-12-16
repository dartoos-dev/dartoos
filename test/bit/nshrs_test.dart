import 'package:dartoos/src/bit/nshrs.dart';
import 'package:test/test.dart';

void main() {
  group('NShl — Bitwise Signed Right-Shift', () {
    test('1 position', () {
      const shift1 = NShrs();
      expect(shift1(105), 52);
      expect(shift1(-105), -53);
    });
    test('negative position', () {
      expect(() => NShrs(-1), throwsA(isA<AssertionError>()));
    });
  });
}
