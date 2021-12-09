import 'package:dartoos/src/bit/and.dart';
import 'package:test/test.dart';

void main() {
  test('Bitwise "AND" Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const and = And();
    expect(and(zeroes, zeroes), zeroes);
    expect(and(zeroes, ones), zeroes);
    expect(and(zeroes, zeroes), zeroes);
    expect(and(zeroes, ones), zeroes);
  });
}
