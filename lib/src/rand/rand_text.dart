import 'dart:math';
import 'dart:typed_data';

import 'package:dartoos/func.dart';

/// Variable-length texts with randomly selected characters from sources of
/// eligible characters.
///
/// For a cryptographically secure random number, see [RandText.secure].
/// Fixed-length generator, see [RandTextLen].
/// Generator with a fixed source of eligible characters, see [RandTextSrc].
class RandText implements BiFunc<String, String, int> {
  /// Random text using the default index randomizer.
  ///
  /// **Note**: for a cryptographically secure random number generator, see
  /// [RandText.secure].
  RandText() : this.custom(Random());

  /// Cryptographically secure random text.
  ///
  /// It uses an instance of [Random.secure] as the index randomizer.
  RandText.secure() : this.custom(Random.secure());

  /// Random Text with custom index generator.
  const RandText.custom(this._index);

  final Random _index;

  /// Returns a [String] with [len] randomly selected characters from [src];
  /// [len] >= 0; [src] must not be empty.
  @override
  String call(String src, int len) {
    assert(len >= 0, 'negative length: $len');
    assert(src.isNotEmpty, 'empty source of eligible characters.');
    final Uint16List codes = Uint16List(len);
    for (var i = 0; i < len; ++i) {
      codes[i] = src.codeUnitAt(_index.nextInt(src.length));
    }
    return String.fromCharCodes(codes);
  }

  /// Syntax sugar — forwards to [call].
  String value(String src, int len) => this(src, len);
}

/// Fixed-length texts with randomly selected characters.
///
/// It is a wrapper over [RandText].
class RandTextLen implements Func<String, String> {
  /// Random texts of length [len]; [len] >= 0.
  RandTextLen(int len) : this._set(len, RandText());

  /// Sets a custom index generator; [len] >= 0.
  RandTextLen.custom(int len, Random rand)
      : this._set(len, RandText.custom(rand));

  /// Cryptographically secure random texts of length [len]; [len] >= 0.
  RandTextLen.secure(int len) : this._set(len, RandText.secure());

  /// Sets the [RandText] instance and the text length.
  const RandTextLen._set(int len, RandText randText)
      : assert(len >= 0, 'negative length: $len'),
        _len = len,
        _randText = randText;

  final int _len;
  final RandText _randText;

  /// Returns a fixed-length [String] with randomly selected characters from
  /// [src]; [src] must not be empty.
  @override
  String call(String src) => _randText(src, _len);

  /// Syntax sugar — forwards to [call].
  String value(String src) => this(src);
}

/// Variable-length texts with randomly selected characters from a fixed source
/// of eligible characters.
///
/// It is a wrapper over [RandText].
class RandTextSrc implements Func<String, int> {
  /// Randomly selected characters from [src]; [src] must not be empty.
  RandTextSrc(String src) : this._set(src, RandText());

  /// Sets a custom index generator [rand]; [src] must not be empty.
  RandTextSrc.custom(String src, Random rand)
      : this._set(src, RandText.custom(rand));

  /// Cryptographically secure texts with randomly selected characters from
  /// [src]; [src] must not be empty.
  RandTextSrc.secure(String src) : this._set(src, RandText.secure());

  /// Sets the [RandText] instance and the source of elegible characters.
  RandTextSrc._set(String src, RandText randText)
      : assert(src.isNotEmpty, 'the source of characters cannot be empty'),
        _src = src,
        _randText = randText;

  final String _src;
  final RandText _randText;

  /// Returns a [String] with [len] randomly selected characters; [len] >= 0.
  @override
  String call(int len) => _randText(_src, len);

  /// Syntax sugar — forwards to [call].
  String value(int len) => this(len);
}
