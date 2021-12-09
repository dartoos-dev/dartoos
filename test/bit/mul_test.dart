import 'package:dartoos/src/bit/mul.dart';
import 'package:test/test.dart';

void main() {
  test('Multiplication Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const mul = Mul();
    expect(mul(zeroes, ones), zeroes); // -1
    expect(mul(ones, zeroes), zeroes); // -1
    expect(mul(1, 1), 1);
    expect(mul(1, -1), -1);
    expect(mul(-1, 1), -1);
    expect(mul(-1, -1), 1);
    expect(mul(4, 4), 16);
    expect(mul(-4, 4), -16);
    expect(mul(-10, -1), 10);
    expect(mul(200, 50), 10000);
  });
}
