import 'package:dartoos/src/rand/rand.dart';
import 'package:test/test.dart';
import 'seq_random.dart';

void main() {
  group('Rand.dig', () {
    test('length', () {
      final zero = Rand(0, 'a');
      expect(zero().length, 0);
      final one = Rand(1, '1');
      expect(one().length, 1);
      final four = Rand(4, 'four');
      expect(four().length, 4);
      expect(four.value.length, 4);
      final aThousand = Rand(1000, 'a throusand');
      expect(aThousand().length, 1000);
      expect(aThousand.value.length, 1000);
    });
    test('zero length', () {
      final zeroLen = Rand(0, 'should always be empty');
      expect(zeroLen().isEmpty, true);
      expect(zeroLen.value.isEmpty, true);
    });
    test('empty source of characters', () {
      expect(() => Rand(1000, ''), throwsA(isA<AssertionError>()));
    });
    test('negative length', () {
      expect(() => Rand(-1, 'should throw'), throwsA(isA<AssertionError>()));
    });
    test('single char source', () {
      final digits = Rand(1000, '0');
      // Must not contain any character other than '0'.
      expect(digits().contains(RegExp('[^0]')), false);
    });
    test('custom index randomizer', () {
      const digits = '0123456789';
      final randDigits = Rand(10, digits, SeqRandom());
      expect('$randDigits', digits);
    });
    test('secure index randomizer', () {
      const digits = '0123456789';
      final nonDigit = RegExp(r'\D');
      final secRandDigits = Rand.secure(100, digits);
      expect(secRandDigits().contains(nonDigit), false);
    });
  });
}
