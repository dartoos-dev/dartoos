import 'package:dartoos/src/bit/shl.dart';
import 'package:test/test.dart';

void main() {
  test('Shl — Shift Left', () {
    const shl = Shl();
    expect(shl(99, 0), 99);
    expect(shl(99, 1000), 0);
    expect(shl(2, 2), 8);
    expect(shl(23, 2), 92);
  });
}
