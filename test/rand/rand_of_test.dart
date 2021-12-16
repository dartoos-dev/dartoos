import 'package:dartoos/rand.dart';
import 'package:test/test.dart';
import 'seq_random.dart';

void main() {
  const alphabet = 'abcdefghijklmnopqrstuvwxyz';
  const digits = '0123456789';
  const hex = '0123456789abcdef';
  // '\D' means non-digit characters.
  final nonDigit = RegExp(r'\D');
  final nonHex = RegExp('[^0-9a-f]');
  group('RandOf.dig', () {
    test('length', () {
      expect(RandOf('a', 0).value.length, 0);
      expect(RandOf('1', 1).value.length, 1);
      expect(RandOf('four', 4).value.length, 4);
      expect(RandOf(alphabet, alphabet.length).value.length, alphabet.length);
      final aThousand = RandOf('a throusand', 1000);
      expect(aThousand().length, 1000);
      expect(aThousand.value.length, 1000);
    });
    test('zero length', () {
      expect(RandOf('a', 0).value.isEmpty, true);
      expect(RandOf(alphabet, 0).value.isEmpty, true);
    });
    test('empty source of characters', () {
      expect(() => RandOf('', 1000), throwsA(isA<AssertionError>()));
    });
    test('negative length', () {
      expect(() => RandOf('error', -1), throwsA(isA<AssertionError>()));
    });
    test('single char source', () {
      final zeroes = RandOf('0', 1000);
      // Must not contain any character other than '0'.
      expect(zeroes().contains(RegExp('[^0]')), false);
    });
    test('custom index randomizer', () {
      final randDigits = RandOf(digits, digits.length, SeqRandom());
      expect('$randDigits', digits);
      final randHex = RandOf(hex, hex.length, SeqRandom());
      expect('$randHex', hex);
      final randAlphabet = RandOf(alphabet, alphabet.length, SeqRandom());
      expect(randAlphabet.value, alphabet);
    });
    test('secure index randomizer', () {
      final randOfSec = RandOf.secure(digits, 100);
      expect(randOfSec().contains(nonDigit), false);
    });
    test('decimal digits only', () {
      final randDig = RandOf.dig(1000, SeqRandom());
      expect(randDig().contains(nonDigit), false);
      expect(randDig.value.contains(nonDigit), false);
    });
    test('hex digits only', () {
      final randDig = RandOf.hex(1000, SeqRandom());
      expect(randDig().contains(nonHex), false);
      expect(randDig.value.contains(nonHex), false);
    });
  });
}
