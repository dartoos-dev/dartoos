import 'package:dartoos/src/bit/inc.dart';
import 'package:test/test.dart';

void main() {
  group('Increment Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    test('by 1', () {
      const inc1 = Inc();
      expect(inc1(zeroes), 0x01);
      expect(inc1(1), 0x02);
      expect(inc1(0xaaaa), 0xaaab);
    });
    test('by 10', () {
      const inc10 = Inc(10);
      expect(inc10(0xaaaaaa), 0xaaaab4);
      expect(inc10(0x01), 0x0b);
      expect(inc10(zeroes), 0xa);
    });
    test('by -1', () {
      const incMinus1 = Inc(-1);
      expect(incMinus1(0x0a), 0x09);
      expect(incMinus1(0x01), zeroes);
      expect(incMinus1(zeroes), ones); // -1
    });
  });
}
