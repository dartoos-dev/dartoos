import 'dart:math';
import 'dart:typed_data';

import '../text/text.dart';

/// Fixed-length texts with randomly selected characters from a source of
/// eligible characters.
///
/// For a cryptographically secure random number, see [Rand.secure].
class RandOf with Text {
  /// Texts of length [len] with randomly selected characters from [src].
  ///
  /// [len] >= 0; src must not be empty.
  ///
  /// For a cryptographically secure random number generator, see [R.secure].
  RandOf(String src, int len, [Random? index])
      : assert(len >= 0, 'Error: negative length.'),
        assert(src.isNotEmpty, 'Error: empty source of eligible characters.'),
        _len = len,
        _src = src,
        _index = index ?? Random();

  /// Fixed-length texts with randomly selected digits [0–9].
  ///
  /// This is the ideal class for generating verification codes.
  ///
  /// ```dart
  ///  final fourDigitCode = RandOf.dig(4).value;
  /// ```
  RandOf.dig(int len, [Random? index]) : this('0123456789', len, index);

  /// Fixed-length strings with randomly selected hex digits [0–9a–f].
  RandOf.hex(int len, [Random? index]) : this('0123456789abcdef', len, index);

  /// Cryptographically secure strings of length [len] with randomly selected
  /// characters from [src].
  ///
  /// [len] >= 0; src must not be empty.
  ///
  /// It uses an instance of [Random.secure] as the index randomizer.
  RandOf.secure(String src, int len) : this(src, len, Random.secure());

  final String _src;
  final int _len;
  final Random _index;

  /// Returns a fixed-length [String] with randomly selected characters from the
  /// predefined source of elegible characters.
  @override
  String call() {
    final Uint16List codes = Uint16List(_len);
    for (var i = 0; i < _len; ++i) {
      codes[i] = _src.codeUnitAt(_index.nextInt(_src.length));
    }
    return String.fromCharCodes(codes);
  }

  /// Syntax sugar — forwards to [call].
  String get value => this();
}
