import 'package:dartoos/rand.dart';
import 'package:test/test.dart';
import 'seq_random.dart';

void main() {
  const alphabet = 'abcdefghijklmnopqrstuvxwyz';
  const digits = '0123456789';
  group('RandText', () {
    final rand = RandText();
    test('output length', () {
      expect(rand('a', 0).length, 0);
      expect(rand.value('1', 1).length, 1);
      expect(rand('four', 4).length, 4);
      expect(rand.value('a thousand', 1000).length, 1000);
    });
    test('zero length', () {
      expect(rand('should always be empty', 0).isEmpty, true);
    });
    test('empty source of characters', () {
      expect(() => rand('', 1000), throwsA(isA<AssertionError>()));
    });
    test('negative length', () {
      expect(() => rand('assertion error', -1), throwsA(isA<AssertionError>()));
    });
    test('single char source', () {
      // Must not contain any character other than '0'.
      expect(rand('0', 1000).contains(RegExp('[^0]')), false);
    });
    test('custom index randomizer', () {
      final randCustom = RandText.custom(SeqRandom());
      expect(randCustom(digits, 10), digits);
    });
    test('secure index randomizer', () {
      final randSec = RandText.secure();
      expect(randSec(digits, 100).contains(RegExp(r'\D')), false);
    });
  });
  group('RandTextSrc', () {
    final randSrc = RandTextSrc(alphabet);
    test('output length', () {
      expect(randSrc(0).length, 0);
      expect(randSrc.value(1).length, 1);
      expect(randSrc(4).length, 4);
      expect(randSrc.value(1000).length, 1000);
    });
    test('zero length', () {
      expect(randSrc(0).isEmpty, true);
    });
    test('empty source of characters', () {
      expect(() => RandTextSrc(''), throwsA(isA<AssertionError>()));
    });
    test('negative length', () {
      expect(() => randSrc(-1), throwsA(isA<AssertionError>()));
    });
    test('single char source', () {
      // Must not contain any character other than '0'.
      expect(RandTextSrc('0').value(1000).contains(RegExp('[^0]')), false);
    });
    test('custom index randomizer', () {
      final randSrcCustom = RandTextSrc.custom(digits, SeqRandom());
      expect(randSrcCustom(10), digits);
    });
    test('secure index randomizer', () {
      final randSrcSec = RandTextSrc.secure(digits);
      expect(randSrcSec.value(100).contains(RegExp(r'\D')), false);
    });
  });
  group('RandTextLen', () {
    test('output length', () {
      expect(RandTextLen(0).value('a').length, 0);
      expect(RandTextLen(1).value('1').length, 1);
      expect(RandTextLen(4).value('four').length, 4);
      expect(RandTextLen(1000).value('a thousand').length, 1000);
    });
    test('zero length', () {
      expect(RandTextLen(0).value(alphabet).isEmpty, true);
    });
    test('empty source of characters', () {
      expect(() => RandTextLen(1000).value(''), throwsA(isA<AssertionError>()));
    });
    test('negative length', () {
      expect(() => RandTextLen(-1), throwsA(isA<AssertionError>()));
    });
    test('single char source', () {
      // Must not contain any character other than '0'.
      expect(RandTextLen(1000).value('0').contains(RegExp('[^0]')), false);
    });
    test('custom index randomizer', () {
      expect(RandTextLen.custom(10, SeqRandom()).value(digits), digits);
    });
    test('secure index randomizer', () {
      final randLenSec = RandTextLen.secure(100);
      expect(randLenSec(digits).contains(RegExp(r'\D')), false);
    });
  });
}
