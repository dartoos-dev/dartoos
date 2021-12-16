import 'dart:math';
import 'dart:typed_data';

import '../text/text.dart';

/// Fixed-length texts with randomly selected characters from a source of
/// eligible characters.
///
/// For a cryptographically secure random number, see [Rand.secure].
class Rand with Text {
  /// Texts of length [len] with randomly selected characters from [src].
  ///
  /// [len] >= 0; src must not be empty.
  ///
  /// For a cryptographically secure random number generator, see [Rand.secure].
  Rand(int len, String src, [Random? index])
      : assert(len >= 0, 'Error: negative length.'),
        assert(src.isNotEmpty, 'Error: empty source of eligible characters.'),
        _len = len,
        _src = src,
        _index = index ?? Random();

  /// Cryptographically secure texts of length [len] with randomly selected
  /// characters from [src].
  ///
  /// [len] >= 0; src must not be empty.
  ///
  /// It uses an instance of [Random.secure] as the index randomizer.
  Rand.secure(int len, String src) : this(len, src, Random.secure());

  final int _len;
  final String _src;
  final Random _index;

  /// Generates fixed-length texts with randomly selected characters from the
  /// source of eligible characters.
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
