import 'package:dartoos/src/rand/rand_dig.dart';
import 'package:test/test.dart';
import 'seq_random.dart';

void main() {
  group('RandDig', () {
    // '\D' means non-digit characters.
    final nonDigit = RegExp(r'\D');
    const digits = '0123456789';
    test('digits only', () {
      final randDig = RandDig(1000, SeqRandom());
      expect(randDig().contains(nonDigit), false);
      expect(randDig.value.contains(nonDigit), false);
    });
    test('custom index randomizer', () async {
      final randDig = RandDig(10, SeqRandom());
      expect(randDig(), digits);
      expect(randDig.value, digits);
      expect('$randDig', digits);
    });
    test('secure', () {
      final secRandDig = RandDig.secure(10);
      expect(secRandDig().contains(nonDigit), false);
      expect(secRandDig.value.contains(nonDigit), false);
    });
  });
}
