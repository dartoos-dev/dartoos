import 'package:dartoos/src/bit/sub.dart';
import 'package:test/test.dart';

void main() {
  test('Subtraction Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const sub = Sub();
    expect(sub(zeroes, zeroes), zeroes);
    expect(sub(ones, zeroes), ones);
    expect(sub(0, 1), ones); // -1
    expect(sub(0xaaaa, 0x4444), 0x6666);
    expect(sub(0, -1), 1);
  });
}
