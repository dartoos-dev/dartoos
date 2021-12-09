import 'package:dartoos/src/bit/or.dart';
import 'package:test/test.dart';

void main() {
  test('Bitwise "OR" Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const or = Or();
    expect(or(ones, zeroes), ones);
    expect(or(ones, ones), ones);
    expect(or(zeroes, zeroes), zeroes);
    expect(or(zeroes, ones), ones);
  });
}
