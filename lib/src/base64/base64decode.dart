import 'dart:async';
import 'dart:typed_data';

import '../bytes.dart';
import 'base64_norm.dart';

/// The decoded bytes of a Base64-encoded text.
class Base64Decode extends Bytes {
  /// Strict Base64 Decoder.
  ///
  /// The Default Base64 encoding scheme —
  /// [RFC 4648 section 4](https://datatracker.ietf.org/doc/html/rfc4648#section-4)
  ///
  /// **alphabet**: A–Za–z0–9+/
  /// **padding**: '=' or '=='.
  ///
  /// The input text must have been properly base64-encoded — which includes
  /// padding. For a more relaxed decoder, see [Base64Decode.norm].
  Base64Decode(FutureOr<String> base64)
      : super(Future(() async => _decoder(await base64)));

  /// Normalizes [encoded] before trying to decode it.
  ///
  /// Normalization process:
  ///
  /// - Unescape any '%' that preceeds '3D' (percent-encoded '=').
  /// - Replace '_' or '-' with '/' or '+'.
  /// - Add trailing padding '=', if needed.
  /// - The normalized text will only contain characters within the base64
  ///   alphabet (A–Za–z0–9/+).
  /// - The total length will always be a multiple of four.
  Base64Decode.norm(FutureOr<String> encoded)
      : super(Future(() async => _decoder(await Base64Norm(encoded))));

  static final _decoder = _ProperlyPadded(const _Base64AsBytes());
}

/// Ensures that the incoming base64 text is properly padded.
class _ProperlyPadded {
  /// Encapsulates the next decoding stage.
  _ProperlyPadded(this._nextStage);

  // the next decoding stage.
  final Uint8List Function(String) _nextStage;

  /// Checks the length (which must be a multiple of 4) and padding (the '=' or
  /// '==' at the end, if needed) of the Base64-encoded text.
  ///
  /// Obs: [base64] cannot be empty.
  /// Throws [FormatException] to indicate an invalid padding or length.
  Uint8List call(String base64) {
    final info = _Base64Info(base64);
    if (info.totalLength % 4 != 0) {
      throw const FormatException('Invalid base64 encoding length');
    }
    switch (info.payloadLength % 4) {
      case 1:
        throw const FormatException('Invalid base64 payload length');
      case 0:
        // There must be no padding.
        if (info.numOfPadChars != 0) {
          throw const FormatException(
            "Invalid base64 padding: unnecessary trailing '='.",
          );
        }
        break;
      case 2:
        // There must be exactly 2 padding chars.
        if (info.numOfPadChars != 2) {
          throw const FormatException(
            "Invalid base64 padding: missing '==' at the end of the encoded text.",
          );
        }
        break;
      case 3:
        // There must be a single padding char at the end.
        if (info.numOfPadChars != 1) {
          throw const FormatException(
            "Invalid base64 padding: there should only be one '=' at the end of the encoded text.",
          );
        }
    }
    return _nextStage(base64);
  }
}

/// Transforms base64 sextets into a sequence of 8-bit bytes.
class _Base64AsBytes {
  /// Ctor.
  const _Base64AsBytes();

  /// a bitmask for the 4 most-significant bits 11110000.
  static const _mask4msb = 0xf0;

  /// a bitmask for the 2 most-significant bits 11000000.
  static const _mask2msb = 0xc0;

  /// a bitmask for the 4 least-significant bits 00001111.
  static const _mask4lsb = 0x0f;

  /// a bitmask for the 2 least-significant bits 00000011.
  static const _mask2lsb = 0x03;

  Uint8List call(String base64) {
    final length = (_Base64Info(base64).payloadLength * 3 / 4.0).floor();
    final octets = Uint8List(length);
    final sextets = _Base64Indexes(base64);
    int i6 = 0; // sextets index.
    int byteGroup = 0; // each group of 24 bits contains 3 bytes.
    for (int i8 = 0; i8 < octets.lengthInBytes; ++i8) {
      // byteGroup is more efficient than i8 % 3
      switch (byteGroup) {
        case 0:
          final sixMsb = sextets[i6] << 2;
          final twoLsb = ((sextets[i6 + 1] << 2) & _mask2msb) >> 6;
          octets[i8] = sixMsb | twoLsb;
          ++i6;
          byteGroup = 1;
          break;
        case 1:
          final fourMsb = (sextets[i6] & _mask4lsb) << 4;
          final fourLsb = ((sextets[i6 + 1] << 2) & _mask4msb) >> 4;
          octets[i8] = fourMsb | fourLsb;
          ++i6;
          byteGroup = 2;
          break;
        case 2:
          final twoMsb = (sextets[i6] & _mask2lsb) << 6;
          final sixLsb = sextets[i6 + 1];
          octets[i8] = twoMsb | sixLsb;
          i6 += 2;
          byteGroup = 0; // resets byteGroup
      }
    }
    return octets;
  }
}

/// Converts each ASCII character into a base64 index.
class _Base64Indexes {
  /// Encapsulates a base64-encoded text.
  const _Base64Indexes(this._base64);

  // The encoded text.
  final String _base64;

  /// Retrieves the corresponding base64 of the character at position [i];
  int operator [](int i) {
    final code = _base64.codeUnitAt(i);
    if (code < 0 || code > 127) {
      throw const FormatException(
        'Illegal base64 character: non-ascii character found.',
      );
    }
    final index = _asciiBase64Indexes[code];
    if (index < 0) {
      throw const FormatException(
        "Invalid base64 character: ascii character other than '[A-Za-z][0-9]+/'.",
      );
    }
    return index;
  }

  static const _asciiBase64Indexes = [
    -1, // 'NUl' 0 ascii
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1, // ' ' <space> 32 ascii
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    62, // '+' 43 ascii
    -1,
    -1,
    -1,
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
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
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
    -1,
    -1,
    -1,
    -1,
    -1,
    -1,
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
    -1,
    -1,
    -1,
    -1,
    -1,
  ];
}

/// Base64-encoded text general information.
class _Base64Info {
  /// Encapsulates the encoded text.
  _Base64Info(this._encoded);

  final String _encoded;

  static const _padChar = '=';

  /// The length of the data without padding characters.
  late final int payloadLength = _encoded.isEmpty
      ? 0
      : !lastCharIsPad
          ? totalLength
          : lastButOneCharIsPad
              ? totalLength - 2
              : totalLength - 1;

  /// The total length of the encoded text.
  int get totalLength => _encoded.length;

  int get numOfPadChars => totalLength - payloadLength;

  bool get lastCharIsPad => _encoded[totalLength - 1] == _padChar;
  bool get lastButOneCharIsPad => _encoded[totalLength - 2] == _padChar;

  String lastNChars(int n) {
    assert(n > 0 && n < totalLength);
    return _encoded.substring(totalLength - n, totalLength);
  }
}
