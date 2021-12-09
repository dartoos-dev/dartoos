import 'package:dartoos/src/rand/rand_hex.dart';
import 'package:test/test.dart';
import 'seq_random.dart';

void main() {
  group('RandHex', () {
    const lowercaseHex = '0123456789abcdef';
    const uppercaseHex = '0123456789ABCDEF';
    final nonLowercaseHex = RegExp('[^0-9a-f]');
    final nonUppercaseHex = RegExp('[^0-9A-F]');
    test('hex digits only', () {
      final lowerHex = RandHex(1000);
      expect(lowerHex().contains(nonLowercaseHex), false);
      expect(lowerHex.value.contains(nonLowercaseHex), false);
      final upperHex = RandHex.upper(1000);
      expect(upperHex().contains(nonUppercaseHex), false);
      expect(upperHex.value.contains(nonUppercaseHex), false);
    });
    test('custom index randomizer', () async {
      final randLowerHex = RandHex(16, SeqRandom());
      expect('$randLowerHex', lowercaseHex);
      final randUpperHex = RandHex.upper(16, SeqRandom());
      expect('$randUpperHex', uppercaseHex);
    });
    test('secure', () {
      final randHexSec = RandHex.secure(16);
      expect(randHexSec().contains(nonLowercaseHex), false);
      final randUpperHexSec = RandHex.upperSecure(16);
      expect(randUpperHexSec().contains(nonUppercaseHex), false);
    });
  });
}
