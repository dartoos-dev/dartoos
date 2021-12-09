import 'dart:math';
import 'dart:typed_data';

import '../text/text.dart';

/// Fixed-length Random Text.
///
/// It generates random text with a predefined length.
///
/// For a cryptographically secure random number, either pass a [Random.secure]
/// instance as the index generator or use [Rand.secure] constructor.
class Rand with Text {
  /// Random text with [src] as the non-empty source of eligible characters,
  /// [len] as the length, and [index] as the index randomizer.
  ///
  /// **Note**: for a cryptographically secure random number generator, pass a
  /// [index] instance using [Random.secure] or use [Rand.secure].
  Rand(int len, String src, [Random? index])
      : assert(len >= 0, 'Error: negative length.'),
        assert(src.isNotEmpty, 'Error: empty source of eligible characters.'),
        _len = len,
        _src = src,
        _index = index ?? Random();

  /// Cryptographically secure random text.
  ///
  /// It uses an instance of [Random.secure] as the index randomizer.
  Rand.secure(int len, String src) : this(len, src, Random.secure());

  final int _len;
  final String _src;
  final Random _index;

  /// Generates text of predefined length with randomly selected characters.
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
