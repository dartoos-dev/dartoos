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
  Base64(FutureOr<Uint8List> bytes)
      : super(_Base64Impl(bytes, _base64Alphabet));

  /// Encodes the utf8-encoded bytes of [str] to Base64 text.
  Base64.utf8(FutureOr<String> str) : this(BytesOf.utf8(str));

  /// Encodes the bytes of [list] to Base64 text.
  Base64.list(FutureOr<List<int>> list) : this(BytesOf.list(list));
}

/// The Default Base64 encoding scheme without padding —
/// [RFC 4648 section 4](https://datatracker.ietf.org/doc/html/rfc4648#section-4)
///
/// **alphabet**: A–Za–z0–9+/
class Base64NoPad extends Text {
  /// Encodes [bytes] to Base64 text without padding characters.
  Base64NoPad(FutureOr<Uint8List> bytes)
      : super(
          _Base64Impl.noPad(bytes, _base64Alphabet),
        );

  /// Encodes the utf8-encoded bytes of [str] to Base64 text.
  Base64NoPad.utf8(String str) : this(BytesOf.utf8(str));

  /// Encodes the bytes of [list] to Base64 text.
  Base64NoPad.list(List<int> list) : this(BytesOf.list(list));
}

/// The Base 64 encoding with an URL and filename safe alphabet —
/// [RFC 4648 section 5](https://datatracker.ietf.org/doc/html/rfc4648#section-5)
///
/// **alphabet**: A–Za–z0–9-_
/// **padding**: '='.
class Base64Url extends Text {
  /// Encodes [bytes] to Base64 text with URL and filename safe alphabet.
  Base64Url(FutureOr<Uint8List> bytes)
      : super(_Base64Impl(bytes, _base64UrlAlphabet));

  /// Encodes the utf8-encoded bytes of [str] to Base64Url text.
  Base64Url.utf8(FutureOr<String> str) : this(BytesOf.utf8(str));

  /// Encodes the bytes of [list] to Base64Url text.
  Base64Url.list(FutureOr<List<int>> list) : this(BytesOf.list(list));
}

/// The Base 64 encoding with an URL and filename safe alphabet without padding
/// — [RFC 4648 section 5](https://datatracker.ietf.org/doc/html/rfc4648#section-5)
///
/// **alphabet**: A–Za–z0–9-_
class Base64UrlNoPad extends Text {
  /// Encodes [bytes] to Base64 text with URL and filename safe alphabet.
  Base64UrlNoPad(FutureOr<Uint8List> bytes)
      : super(_Base64Impl.noPad(bytes, _base64UrlAlphabet));

  /// Encodes the utf8-encoded bytes of [str] to Base64Url text.
  Base64UrlNoPad.utf8(FutureOr<String> str) : this(BytesOf.utf8(str));

  /// Encodes the bytes of [list] to Base64Url text.
  Base64UrlNoPad.list(FutureOr<List<int>> list) : this(BytesOf.list(list));
}

/// The actual implementation of Base64.
class _Base64Impl extends Text {
  /// Default Base64.
  _Base64Impl(FutureOr<Uint8List> bytesToEncode, String alphabet)
      : super(
          Future(() async {
            final unencoded = await bytesToEncode;
            return _Base64Str(
              _Pad(_Base64Indexes(unencoded, alphabet), unencoded),
            ).toString();
          }),
        );

  /// Base64 with no trailing padding '='.
  _Base64Impl.noPad(FutureOr<Uint8List> bytesToEncode, String alphabet)
      : super(
          Future(() async {
            final unencoded = await bytesToEncode;
            return _Base64Str(
              _Base64Indexes.noPad(unencoded, alphabet),
            ).toString();
          }),
        );
}

/// The base64 alphabet.
const String _base64Alphabet =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

/// The base64url alphabet.
const String _base64UrlAlphabet =
    "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

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
    }
    return base64;
  }
}

/// Bytes as a list of base64 alphabet sextets indexes.
class _Base64Indexes {
  /// Converts an unencoded list of bytes into a list of sextets indexes. It
  /// will append one or two extra bytes for padding, If needed.
  _Base64Indexes(Uint8List unencoded, String alphabet)
      : this.main(unencoded, alphabet, _NewBytes(unencoded));

  /// Converts an unencoded list of bytes into a list of sextets indexes without
  /// extra space for padding.
  _Base64Indexes.noPad(Uint8List unencoded, String alphabet)
      : this.main(unencoded, alphabet, _NewBytes.noPad(unencoded));

  /// Main ctor.
  _Base64Indexes.main(this._unencoded, this._alphabet, this._newBytes);

  // The unencoded bytes.
  final Uint8List _unencoded;
  // The set of characters to work with.
  final String _alphabet;
  // Something that produces a zero-initialized list of bytes.
  final Uint8List Function() _newBytes;

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
    int byteGroup = 0; // the group of 8-bits in 24-bits.
    int index = 0x00; // the 6-bits index of the base64 alphabet.
    int i6 = 0; //sextets index
    final sextets = _newBytes();
    for (int i8 = 0; i8 < _unencoded.lengthInBytes; ++i8) {
      final octet = _unencoded[i8];
      switch (byteGroup) {
        case 0:
          // sets the sextet to the 6-msb of the octet.
          index = (octet & _mask6Msb) >> 2;
          sextets[i6] = _alphabet.codeUnitAt(index);
          // sets the 2-most-significant bits of the next index to the
          // 2-least-significant bits of the current octet (byte).
          index = (octet & _mask2Lsb) << 4;
          ++i6;
          byteGroup = 1;
          break;
        case 1:
          // combines the partial value of index (2-msb) with the 4-msb of the
          // current octet.
          index |= (octet & _mask4Msb) >> 4;
          sextets[i6] = _alphabet.codeUnitAt(index);
          // sets the 4-msb of the next index to the 4-lsb of the current octet
          // (byte).
          index = (octet & _mask4Lsb) << 2;
          ++i6;
          byteGroup = 2;
          break;
        case 2:
          // combines the partial value of the index (4-msb) with the 2-msb of
          // the current octet.
          index |= (octet & _mask2Msb) >> 6;
          sextets[i6] = _alphabet.codeUnitAt(index);
          // sets the next sextet as the 6-lsb of the current octet — whole sextet value.
          index = octet & _mask6Lsb;
          sextets[i6 + 1] = _alphabet.codeUnitAt(index);
          i6 += 2;
          byteGroup = 0; // resets byteGroup.
      }
    }
    // _unencoded.lengthInBytes % 3 != 0
    if (byteGroup != 0) {
      sextets[i6] = _alphabet.codeUnitAt(index);
    }
    return sextets;
  }
}

/// List for base64 encoded bytes.
class _NewBytes {
  /// Makes a zero-initialized (0x00) list of bytes whose length is a multiple
  /// of four and at least 4/3 of the length of [unencoded].
  _NewBytes(Uint8List unencoded)
      : this.main(() {
          final length = _fourThirdOf(unencoded);
          final mod4 = length % 4;
          return mod4 == 0 ? Uint8List(length) : Uint8List(length + 4 - mod4);
        });

  /// Makes a zero-initialized (0x00) list of bytes whose length is always 4/3
  /// of the length of [unencoded].
  _NewBytes.noPad(Uint8List unencoded)
      : this.main(() => Uint8List(_fourThirdOf(unencoded)));

  /// Main ctor.
  _NewBytes.main(this._toNewBytes);

  static int _fourThirdOf(Uint8List bytes) =>
      (bytes.lengthInBytes * 4 / 3.0).ceil();

  // The algorithm for computing the byte list.
  final Uint8List Function() _toNewBytes;

  /// Retrieves a zero-initialized list of bytes.
  Uint8List call() => _toNewBytes();
}
