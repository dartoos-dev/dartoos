import 'dart:async';
import 'dart:convert';

import '../text.dart';

/// Represents a normalized base64-encoded text.
class Base64Norm extends Text {
  /// Normalization process:
  ///
  /// - Unescape any '%' that preceeds '3D' (percent-encoded '=').
  /// - Replace '_' or '-' with '/' or '+'.
  /// - Add trailing padding '=', if needed.
  /// - The normalized text will only contain characters within the base64
  ///   alphabet (A–Za–z0–9/+).
  /// - The total length will always be a multiple of four.
  Base64Norm(FutureOr<String> text)
      : super(
          Future(() async {
            final normalized = _NormChars(_TrimEncodedEquals(await text));
            return normalized();
          }),
        );
}

/// Text with no trailing percent-encoded '='.
class _TrimEncodedEquals {
  /// Removes up to two percent-encoded '=' (%3d or %3D) at the end of the given
  /// base64-encoded text.
  _TrimEncodedEquals(this._text);

  final String _text;

  String call() {
    if (_text.isEmpty) return '';

    final length = _text.length;
    if (length < 2) {
      throw const FormatException('Invalid base64-encoded text length: 1');
    }
    final lastScapedPos = length - 3;

    if (lastScapedPos > 2) {
      if (_isScapeChar(lastScapedPos)) {
        if (!_isCorrectlyScaped(lastScapedPos)) {
          throw const FormatException(
            "Invalid percent-encoding of trailing '=' ",
          );
        } else {
          final lastButOneScapedPos = lastScapedPos - 3;
          if (_isScapeChar(lastButOneScapedPos)) {
            if (!_isCorrectlyScaped(lastButOneScapedPos)) {
              throw const FormatException(
                "Invalid percent-encoding of trailing '=' ",
              );
            }
            return _text.substring(0, lastButOneScapedPos);
          }
        }
        return _text.substring(0, lastScapedPos);
      }
    }
    return _text;
  }

  bool _isScapeChar(int pos) => _text[pos] == '%';
  bool _isCorrectlyScaped(int percentPos) {
    final asciiPart1 = _text[percentPos + 1];
    final asciiPart2 = _text[percentPos + 2];
    return asciiPart1 == '3' && (asciiPart2 == 'D' || asciiPart2 == 'd');
  }
}

/// Normalizes any '-' or '_' to '+' or '/'; in addition, appends correct
/// padding '=' if necessary.
class _NormChars {
  /// Encapsulates the previous stage of the normalization process.
  _NormChars(this._prevStage);

  static const _equal = 0x3d; // '='
  static const _minus = 0x2d; // '-'
  static const _plus = 0x2b; // '+'
  static const _slash = 0x2f; // '/'
  static const _underline = 0x5f; // '_'
  /// represents an illegal ascii value.
  static const _illegal = -1;

  /// A previous stage of the normalization process.
  final String Function() _prevStage;

  /// The normalized input.
  String call() {
    // the original text to be normalized
    final origin = _prevStage();
    final payloadLength = _payloadLengthOf(origin);
    final sextets = utf8.encode(_prevStage());
    for (int i = 0; i < payloadLength; ++i) {
      final sextet = sextets[i];
      if (sextet < 0x00 || sextet > 0xff) {
        throw const FormatException(
          'Base64-encoded text contains non-ascii character(s).',
        );
      }
      final base64Index = _extendedBase64Indexes[sextet];
      if (base64Index == _illegal) {
        throw const FormatException(
          "Base64-encoded text contains an illegal ascii symbol"
          " (a character other than 'A–Za–z0–9+-/_').",
        );
      }
      switch (sextet) {
        case _minus:
          sextets[i] = _plus;
          break;
        case _underline:
          sextets[i] = _slash;
      }
    }
    return _decode(sextets);
  }

  int _payloadLengthOf(String origin) {
    if (origin.length < 4) return 0;
    final totalLength = origin.length;
    final lastButOne = origin.codeUnitAt(totalLength - 2);
    final last = origin.codeUnitAt(totalLength - 1);
    if (lastButOne == _equal && last == _equal) return totalLength - 2;
    if (last == _equal) return totalLength - 1;
    return totalLength;
  }

  String _decode(List<int> bytes) {
    // The necessary padding for the base64-encoded text.
    String padding = '';
    switch (bytes.length % 4) {
      case 1:
        throw const FormatException('Invalid base64 length.');
      case 2:
        padding = '==';
        break;
      case 3:
        padding = '=';
        break;
    }
    final decoded = utf8.decode(bytes);
    return padding.isEmpty ? decoded : '$decoded$padding';
  }

  // It also includes '-', '+' and '%' as allowed characters.
  static const _extendedBase64Indexes = <int>[
    _illegal, // 'NUl' 0 ascii
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal, // ' ' <space> 32 ascii
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    62, // '+' 43 ascii
    _illegal,
    62, // '-' 45 ascii
    _illegal,
    63, // '/' 47 ascii
    52, // '0' 48 ascii
    53, // '1'
    54, // '2'
    55, // '3'
    56, // '4'
    57, // '5'
    58, // '6'
    59, // '7'
    60, // '8'
    61, // '9' 67 ascii
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    0, // 'A' 65 ascii
    1, // 'B'
    2, // 'C'
    3, // 'D'
    4, // 'E'
    5, // 'F'
    6, // 'G'
    7, // 'H'
    8, // 'I'
    9, // 'J'
    10, // 'K'
    11, // 'L'
    12, // 'M'
    13, // 'N'
    14, // 'O'
    15, // 'P'
    16, // 'Q'
    17, // 'R'
    18, // 'S'
    19, // 'T'
    20, // 'U'
    21, // 'V'
    22, // 'W'
    23, // 'X'
    24, // 'Y'
    25, // 'Z' 90 ascii
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    63, // '_' 95 ascii
    _illegal,
    26, // 'a' 97 ascii
    27, // 'b'
    28, // 'c'
    29, // 'd'
    30, // 'e'
    31, // 'f'
    32, // 'g'
    33, // 'h'
    34, // 'i'
    35, // 'j'
    36, // 'k'
    37, // 'l'
    38, // 'm'
    39, // 'n'
    40, // 'o'
    41, // 'p'
    42, // 'q'
    43, // 'r'
    44, // 's'
    45, // 't'
    46, // 'u'
    47, // 'v'
    48, // 'w'
    49, // 'x'
    50, // 'y'
    51, // 'z' 122 ascii
    _illegal,
    _illegal,
    _illegal,
    _illegal,
    _illegal,
  ];
}
