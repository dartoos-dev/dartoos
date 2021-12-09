import 'package:dartoos/src/bit/div.dart';
import 'package:test/test.dart';

void main() {
  test('Truncating Division Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const div = Div();
    expect(div(zeroes, ones), zeroes); // -1
    expect(div(1, 1), 1);
    expect(div(1, -1), -1);
    expect(div(-1, 1), -1);
    expect(div(-1, -1), 1);
    expect(div(999, -1), -999);
    expect(div(15, 2), 7);
    expect(div(16, 2), 8);
    expect(div(17, 2), 8);
    expect(div(5, 6), 0);
    expect(div(200, 50), 4);
    expect(div(101, 100), 1);
    expect(div(199, 100), 1);
  });
}
