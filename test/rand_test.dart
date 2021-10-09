import 'dart:math';

import 'package:dartoos/src/rand.dart';
import 'package:test/test.dart';

Future<void> main() async {
  group('Rand.dig', () {
    test('length', () async {
      final four = await Rand.dig(4, Random.secure());
      expect(four.length, 4);
    });
    test('digits only', () async {
      final digits = await Rand.dig(10, SeqIndexRandom());
      // Regexp '\D' means non-digit characters
      // the generated value cannot contain any non-digit character
      expect(digits.contains(RegExp(r'\D')), false);
    });
    test('decimal digits [0–9]', () async {
      final decimalDigits = await Rand.dig(10, SeqIndexRandom());
      expect(decimalDigits, '0123456789');
    });
  });
  group('Rand.hex', () {
    test('length', () async {
      expect((await Rand.hex(1)).length, 1);
      expect((await Rand.hex(5)).length, 5);
    });
    test('hex digits only', () async {
      final hex = await Rand.hex(10, SeqIndexRandom());
      // the generated value cannot contain any non-hex character
      expect(hex.contains(RegExp('[^0-9a-f]')), false);
    });
    test('hexadecimal digits [0–9a–f]', () async {
      final hexDigits = await Rand.hex(16, SeqIndexRandom());
      expect(hexDigits, '0123456789abcdef');
    });
  });
  group('Rand.str', () {
    test('length', () async {
      final one = await Rand.str(1, 'abc');
      expect(one.length, 1);
    });
    test('custom characters source', () async {
      final custom = await Rand.str(100, 'a', SeqIndexRandom());
      expect(custom.length, 100);

      /// Must not contain any character other than 'a'
      expect(custom.contains(RegExp('[^a]')), false);
    });
  });
}

/// Sequentially generated integer values; quite the opposite of
/// random!!!
class SeqIndexRandom implements Random {
  int _counter = 1;
  int _currBound = 1;

  @override
  bool nextBool() => throw UnsupportedError('nextBool not implemented');
  @override
  double nextDouble() => throw UnsupportedError('nextDouble not implemented');

  /// Generates sequential integers from 0 up to bound - 1.
  /// If [bound] changes, the counter is reset so that the first
  /// value for the new max is 0.
  @override
  int nextInt(int bound) {
    if (_currBound != bound) {
      _currBound = bound;
      _counter = bound;
    }
    final value = _counter % _currBound;
    ++_counter;
    return value;
  }
}
