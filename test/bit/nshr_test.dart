import 'package:dartoos/src/bit/nshr.dart';
import 'package:test/test.dart';

void main() {
  group('NShl — Bitwise Right-Shift', () {
    test('1 position', () {
      const shift1 = NShr();
      expect(shift1(105), 52);
      expect(shift1(105), 52);
      expect(shift1(-105), 9223372036854775755);
      expect(shift1(-105), 9223372036854775755);
    });
  });
}
