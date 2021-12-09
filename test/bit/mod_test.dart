import 'package:dartoos/src/bit/mod.dart';
import 'package:test/test.dart';

void main() {
  test('Reminder — "Mod" Operation', () {
    const ones = 0xFFFFFFFFFFFFFFFF;
    const zeroes = 0x000000000000000;
    const mod = Mod();
    expect(mod(zeroes, ones), zeroes); // -1
    expect(mod(ones, ones), zeroes);
    expect(mod(1, -1), 0);
    expect(mod(-1, 1), 0);
    expect(mod(-1, -1), 0);
    expect(mod(999, 1), 0);
    expect(mod(999, 999), 0);
    expect(mod(15, 2), 1);
    expect(mod(16, 2), 0);
    expect(mod(17, 2), 1);
    expect(mod(5, 6), 5);
    expect(mod(50, 100), 50);
    expect(mod(101, 100), 1);
    expect(mod(199, 100), 99);
    expect(mod(1111, 9), 4);
    expect(mod(123456789, 10), 9);
    expect(mod(123456789, 100), 89);
    expect(mod(123456789, 1000), 789);
  });
}
