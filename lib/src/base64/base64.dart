import 'dart:async';
import 'dart:typed_data';

import '../bytes.dart';

import '../text.dart';

/// The Default Base64 encoding scheme —
/// [RFC 4648 section 4](https://datatracker.ietf.org/doc/html/rfc4648#section-4)
///
/// **alphabet**: A–Za–z0–9+/
/// **padding**: '='.
class Base64 extends Text {
  /// Encodes [bytes] to Base64 text.
  Base64(FutureOr<Uint8List> bytes) : super(_Base64Impl(bytes));

  /// Encodes the utf8-encoded bytes of [str] to Base64 text.
  Base64.utf8(String str) : this(BytesOf.utf8(str));

  /// Encodes the bytes of [list] to Base64 text.
  Base64.list(List<int> list) : this(BytesOf.list(list));
}

/// The Base 64 encoding with an URL and filename safe alphabet —
/// [RFC 4648 section 5](https://datatracker.ietf.org/doc/html/rfc4648#section-5)
///
/// **alphabet**: A–Za–z0–9-_
/// **padding**: '='.
class Base64Url extends Text {
  /// Encodes [bytes] to Base64 text with URL and filename safe alphabet.
  Base64Url(FutureOr<Uint8List> bytes) : super(_Base64Impl.url(bytes));

  /// Encodes the utf8-encoded bytes of [str] to Base64Url text.
  Base64Url.utf8(String str) : this(BytesOf.utf8(str));

  /// Encodes the bytes of [list] to Base64Url text.
  Base64Url.list(List<int> list) : this(BytesOf.list(list));
}

/// The actual implementation of Base64.
class _Base64Impl extends Text {
  /// Default Base64.
  _Base64Impl(FutureOr<Uint8List> bytesToEncode)
      : this._alphabet(bytesToEncode, _base64Alphabet);

  /// Url Base64
  _Base64Impl.url(FutureOr<Uint8List> bytesToEncode)
      : this._alphabet(bytesToEncode, _base64UrlAlphabet);

  /// Helper ctor.
  _Base64Impl._alphabet(FutureOr<Uint8List> bytesToEncode, String alphabet)
      : super(
          Future(() async {
            final bytes = await bytesToEncode;
            return _Base64Str(
              _Pad(
                _Base64Bytes(_Base64Indexes(bytes), alphabet),
                bytes,
              ),
            ).toString();
          }),
        );

  /// The base64 alphabet.
  static const String _base64Alphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

  /// The base64url alphabet.
  static const String _base64UrlAlphabet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";
}

/// Base64 bytes as [String].
class _Base64Str {
  /// Decodes the Base64 bytes to the corresponding string.
  const _Base64Str(this._toBase64);

  /// Something that retrieves Base64 bytes.
  final Uint8List Function() _toBase64;

  @override
  String toString() => String.fromCharCodes(_toBase64());
}

/// Base64 with padding characters.
class _Pad {
  /// Inserts padding characters '=', if needed.
  _Pad(this._toBase64, Uint8List unencoded)
      : _inputLength = unencoded.lengthInBytes;

  final int _inputLength;

  // The base64 array to be padded.
  final Uint8List Function() _toBase64;

  /// The '=' ASCII code.
  static const _pad = 0x3d;

  Uint8List call() {
    final base64 = _toBase64();
    switch (_inputLength % 3) {
      case 0:
        break; // No padding chars in this case.
      case 1: // Two padding chars.
        base64.fillRange(base64.length - 2, base64.length, _pad);
        break;
      case 2: // One padding char.
        base64[base64.length - 1] = _pad;
        break;
    }
    return base64;
  }
}

/// A list of sextets indexes as a base64 byte list.
class _Base64Bytes {
  /// Transforms a list of sextets indexes into a list of base64 encoded bytes.
  const _Base64Bytes(this._toIndexes, this._alphabet);

  /// Something that retrieves a list of sextets indexes.
  final Uint8List Function() _toIndexes;
  final String _alphabet;

  Uint8List call() {
    final base64 = _toIndexes();
    for (int i = 0; i < base64.lengthInBytes; ++i) {
      final index = base64[i];
      base64[i] = _alphabet.codeUnitAt(index);
    }
    return base64;
  }
}

/// Bytes as a list of base64 alphabet sextets indexes.
class _Base64Indexes {
  /// Converts an unencoded list of bytes into a list of sextets indexes.
  const _Base64Indexes(this._unencoded);
  // The unencoded bytes.
  final Uint8List _unencoded;

  /// a bitmask for the 6 most-significant bits 11111100.
  static const _mask6Msb = 0xfc;

  /// a bitmask for the 4 most-significant bits 11110000.
  static const _mask4Msb = 0xf0;

  /// a bitmask for the 2 most-significant bits 11000000.
  static const _mask2Msb = 0xC0;

  /// a bitmask for the 6 least-significant bits 00111111.
  static const _mask6Lsb = 0x3f;

  /// a bitmask for the 4 least-significant bits 00001111.
  static const _mask4Lsb = 0x0f;

  /// a bitmask for the 2 least-significant bits 00000011.
  static const _mask2Lsb = 0x03;

  /// List of sextets indexes.
  Uint8List call() {
    final indexes = _NewListOfBytes(_unencoded).value;
    int sextetIndex = 0;
    for (int octetIndex = 0;
        octetIndex < _unencoded.lengthInBytes;
        ++octetIndex) {
      final octet = _unencoded[octetIndex];
      switch (octetIndex % 3) {
        case 0:
          {
            // sets the sextet to the 6-msb of the octet.
            indexes[sextetIndex] = (octet & _mask6Msb) >> 2;
            // sets the 2-most-significant bits of the next sextet to the
            // 2-least-significant bits of the current octet (byte).
            indexes[sextetIndex + 1] = (octet & _mask2Lsb) << 4; // 00110000
            ++sextetIndex;
            break;
          }
        case 1:
          {
            /// combines the partial value of the sextet (2-msb) with the 4-msb of the
            /// current octet.
            indexes[sextetIndex] =
                indexes[sextetIndex] | ((octet & _mask4Msb) >> 4);
            // sets the 4-msb of the next sextet to the 4-lsb of the current
            // octet (byte).
            indexes[sextetIndex + 1] = (octet & _mask4Lsb) << 2; // 00111100
            ++sextetIndex;
            break;
          }
        case 2:
          {
            /// combines the partial value of the sextet (4-msb) with the 2-msb
            /// of the current octet.
            indexes[sextetIndex] =
                indexes[sextetIndex] | ((octet & _mask2Msb) >> 6);
            // sets the next sextet as the 6-lsb of the current octet — whole
            // sextet value.
            indexes[sextetIndex + 1] = octet & _mask6Lsb;
            sextetIndex += 2;
            break;
          }
      }
    }
    return indexes;
  }
}

/// List for base64 encoded bytes.
class _NewListOfBytes {
  /// Makes a zero-initialized (0x00) list of bytes to hold base64 encoded
  /// bytes.
  const _NewListOfBytes(this._unencoded);

  final Uint8List _unencoded;

  /// Retrieves a zero-initialized list whose length is a multiple of four.
  Uint8List get value {
    final length = (_unencoded.lengthInBytes * 4 / 3.0).ceil();
    final mod4 = length % 4;
    return mod4 == 0 ? Uint8List(length) : Uint8List(length + 4 - mod4);
  }
}
