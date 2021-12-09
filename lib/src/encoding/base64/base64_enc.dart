import 'dart:typed_data';

import 'base64.dart';

/// Standard Base64 Encoder
///
/// [Base64](https://datatracker.ietf.org/doc/html/rfc4648#section-4)
class Base64Enc implements Base64Encoder {
  /// Base64.
  ///
  /// **alphabet**: A–Za–z0–9+/
  /// **padding**: '='
  const Base64Enc() : this._set(const _Base64Str(_Pad(_Base64Indexes(_std))));

  /// Base64 without padding '=' signs.
  ///
  /// **alphabet**: A–Za–z0–9+/
  const Base64Enc.noPad()
      : this._set(const _Base64Str(_Base64Indexes.noPad(_std)));

  /// Sets the encoding algorithm.
  const Base64Enc._set(this._toBase64);

  // Converts bytes to Base64-encoded text.
  final _Base64Str _toBase64;
  // final String Function(Uint8List) _toBase64;

  // Standard Base64 alphabet [A–Za–z0–9+/]
  static const String _std =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

  /// Returns the Base64-encoded text of [unencoded].
  @override
  String call(Uint8List unencoded) => _toBase64(unencoded);
}

/// URL- and filename-safe Base64 Encoder
///
/// [Base64Url](https://datatracker.ietf.org/doc/html/rfc4648#section-5)
class Base64UrlEnc implements Base64Encoder {
  /// Base64Url
  ///
  /// **default alphabet**: A–Za–z0–9-_
  /// **padding**: '='.
  const Base64UrlEnc()
      : this._set(const _Base64Str(_Pad(_Base64Indexes(_url))));

  /// Base64Url without padding '=' signs.
  ///
  /// **alphabet**: A–Za–z0–9-_
  const Base64UrlEnc.noPad()
      : this._set(const _Base64Str(_Base64Indexes.noPad(_url)));

  /// Sets the Base64Url encoding algorithm.
  const Base64UrlEnc._set(this._toBase64Url);

  // Converts bytes to Base64Url-encoded text.
  final _Base64Str _toBase64Url;
  //String Function(Uint8List) _toBase64Url;

  // Base64Url alphabet.
  static const String _url =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

  /// Returns the Base64Url-encoded text of [unencoded].
  @override
  String call(Uint8List unencoded) => _toBase64Url(unencoded);
}

/// Base64 bytes as [String].
class _Base64Str {
  /// Decodes the Base64 bytes to the corresponding string.
  const _Base64Str(this._toBase64);

  // Something that retrieves a list filled with Base64-encoded bytes.
  final _Filler _toBase64;

  /// [unencoded] to Base64-encoded text.
  String call(Uint8List unencoded) =>
      String.fromCharCodes(_toBase64(unencoded));
}

/// Base64 encoding fillers
///
/// For classes that somehow fills the list of bytes with Base64-encoded values.
abstract class _Filler {
  Uint8List call(Uint8List bytes);
}

/// Base64 with padding characters.
class _Pad implements _Filler {
  /// Inserts equal sign end padding '=' if needed.
  const _Pad(this._toBase64);

  // The base64 array to be padded.
  final _Base64Indexes _toBase64;

  /// The ASCII code of the '=' sign.
  static const _pad = 0x3d;

  @override
  Uint8List call(Uint8List unencoded) {
    final base64 = _toBase64(unencoded);
    switch (unencoded.lengthInBytes % 3) {
      case 0:
        break; // The length is a multiple of 3; no padding chars in this case.
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
class _Base64Indexes implements _Filler {
  /// Converts an unencoded list of bytes into a list of sextets indexes. It
  /// will append one or two extra bytes for padding, If needed.
  const _Base64Indexes(String alphabet)
      : this.main(alphabet, const _NewBytes());

  /// Converts an unencoded list of bytes into a list of sextets indexes without
  /// extra space for padding.
  const _Base64Indexes.noPad(String alphabet)
      : this.main(alphabet, const _NewBytesNoPad());

  /// Main ctor.
  const _Base64Indexes.main(this._alphabet, this._newBytes);

  // The set of characters to work with.
  final String _alphabet;
  // A zero-initialized list of bytes for the sextets.
  final _BytesForBase64 _newBytes;

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
  @override
  Uint8List call(Uint8List unencoded) {
    var byteGroup = 0; // the group of 8-bits in 24-bits.
    var index = 0x00; // the 6-bits index of the base64 alphabet.
    var i6 = 0; //sextets index
    final sextets = _newBytes(unencoded.lengthInBytes);
    final unencodedLength = unencoded.lengthInBytes;
    for (var i8 = 0; i8 < unencodedLength; ++i8) {
      final octet = unencoded[i8];
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

/// List of bytes for base64.
abstract class _BytesForBase64 {
  /// Returns a zero-initialized list of bytes.
  ///
  /// [len] the length of the list of unencoded bytes.
  Uint8List call(int len);
}

class _NewBytes implements _BytesForBase64 {
  /// Ctor.
  const _NewBytes([_Frac frac = const _Frac.fourThirds()]) : _fracOf = frac;

  final _Frac _fracOf;
  @override
  Uint8List call(int len) {
    final length = _fracOf(len);
    final mod4 = length % 4;
    return mod4 == 0 ? Uint8List(length) : Uint8List(length + 4 - mod4);
  }
}

class _NewBytesNoPad implements _BytesForBase64 {
  /// Ctor.
  const _NewBytesNoPad();

  static const _Frac _fourThirdsOf = _Frac.fourThirds();

  @override
  Uint8List call(int len) => Uint8List(_fourThirdsOf(len));
}

// The least integer that is not smaller than a fraction of a given value.
class _Frac {
  /// Encapsulates the numerator and denominator of the fraction.
  const _Frac(this._num, this._den);

  /// Four-thirds of a value.
  const _Frac.fourThirds() : this(4, 3);
  // numerator
  final int _num;
  // denominator
  final int _den;

  double get _frac => _num / _den;

  /// Returns the least integer that is not smaller than the predefined fraction
  /// of [origin].
  int call(int origin) => (origin * _frac).ceil();
}
