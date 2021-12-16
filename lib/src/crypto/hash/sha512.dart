import 'dart:typed_data';

import 'package:dartoos/bit.dart';
import 'package:dartoos/crypto.dart';
import 'package:dartoos/func.dart';

/// SHA-512 hash function.
///
/// Its output (message digest) size is 512 bits (64 bytes).
///
/// See also:
///
/// - [RFC 6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.2)
const HashByte sha512 = _Sha512();

/// SHA-384 hash function.
///
/// Its a truncated version of [sha512] with different initial hash values.
///
/// See also:
///
/// - [RFC 6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.2)
const HashByte sha384 = _Sha384();

/// The SHA-512 variant of the SHA-2 family (Secure Hash Algorithm 2).
///
/// [RFC6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.2)
class _Sha512 with ChunksOf128Bytes {
  /// SHA-512 cryptographic hash function.
  const _Sha512();

  /// Retrieves the 512-bit (64-bytes) hash value (digest) of [input].
  @override
  Uint8List call(Uint8List input) => _digest512(input);

  static const _digest512 = _Padding(_MsgSched(_ComprFactory.sha512()));
}

/// The SHA-384 variant of the SHA-2 family
///
/// [RFC6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.2)
class _Sha384 with ChunksOf128Bytes {
  /// SHA-384 cryptographic hash function.
  const _Sha384();

  /// Retrieves the 384-bit (48-byte) hash value (digest) of [input].
  @override
  Uint8List call(Uint8List input) =>
      _digest384(input).buffer.asUint8List(0, 48);

  static const _digest384 = _Padding(_MsgSched(_ComprFactory.sha384()));
}

/// The padding stage.
///
/// The purpose of message padding is to make the total length of a padded
/// message be a multiple of 512 bits.
///
/// Padding:
/// - 1. begin with the original message of length L bits and append a single
///     '1' bit.
/// - 2. append K '0's, where K is the minimum number >= 0 such that L + 1 + K +
///      128 is a multiple of 1024, that is, (L + 1 + K) mod 1024 = 896.
/// - 3. append L as a 128-bit big-endian integer, making the total
///      post-processed length a multiple of 1024 bits such that the bits in the
///      message are L 1 00..<K 0's>..00 <L as 128 bit integer> = k*1024 total
///      bits.
///
/// Example taken from [rfc6234[(https://datatracker.ietf.org/doc/html/rfc6234)
///
/// Suppose the original message is the bit string
///
///   _01100001 01100010 01100011 01100100 01100101_
///
///  After step (1) this gives
///
///   _01100001 01100010 01100011 01100100 01100101 1_
///
/// Since L = 40, the number of bits in the above is 41 and K = 855 "0"s are
/// appended, making the total now 896. This gives the following in hex:
///
///   _61626364 65800000 00000000 00000000_
///   _00000000 00000000 00000000 00000000_
///   _00000000 00000000 00000000 00000000_
///   _00000000 00000000_
///
/// The 128-bit representation of L = 40 is hex 00000000 00000000 00000000
/// 00000028. Hence the final padded message is the following hex
///
///   _61626364 65800000 00000000 00000000_
///   _00000000 00000000 00000000 00000000_
///   _00000000 00000000 00000000 00000000_
///   _00000000 00000000 00000000 00000028_
class _Padding {
  /// Encapsulates the next stage.
  const _Padding(this._msgSched);

  final _MsgSched _msgSched;

  /// Pads the 'L-bits' of [input] message with a single '1' bit followed by a
  /// total of K '0' bits until L + K + 128 is a multiple of 1024. The
  /// post-processed length of [input] is a multiple of 1024.
  Uint8List call(Uint8List input) {
    assert(isLengthSupported(input));
    final info = _PadInfo(input);
    final padded = (BytesBuilder(copy: false)
          ..add(input)
          ..add(info.padding)
          ..add(info.lengthBigEndian))
        .toBytes()
        .buffer
        .asByteData();
    return _msgSched(padded);
  }
}

// Performs rotate-right operations.
const _rotr64 = Rotr.w64();

/// Process the message in successive chunks.
class _MsgSched {
  /// Sets the factory of [_Compr] instances.
  const _MsgSched(this._toCompr);

  /// A factory of [_Compr] instances.
  final Scalar<_Compr> _toCompr;

  static const _bytesPerWord = 8;
  static const _bytesPerHalfWord = _bytesPerWord ~/ 2;
  static const _bytesPerChunck = 128;

  // A [ByteData] instance is used to prevent endianness errors.
  Uint8List call(ByteData message) {
    // The length of the input message must always be a multiple of 128 bytes
    // (1024 bits).
    assert(message.lengthInBytes % _bytesPerChunck == 0);
    // The compression phase.
    final compression = _toCompr();
    // Message Schedule (w) of eighty 64-bit words w[0…79].
    final w = Uint64List(80);
    // The number of 128-byte (1024-bit) chunks of data from input.
    final total = message.lengthInBytes;
    // For each chunck of 128 bytes, perform...
    for (var chunck = 0; chunck < total; chunck += _bytesPerChunck) {
      // copy chunk into first 16 words w[0..15] of the message schedule array
      for (var i = 0; i < 16; ++i) {
        final offset1 = (i * _bytesPerWord) + chunck;
        final offset2 = offset1 + _bytesPerHalfWord;
        w[i] = (message.getUint32(offset1) << 32) | message.getUint32(offset2);
      }
      // Extend the first 16 words into the remaining 64 words w[16..79] of the
      // message schedule array
      for (var i = 16; i < 80; ++i) {
        w[i] = _ssig1(w[i - 2]) + w[i - 7] + _ssig0(w[i - 15]) + w[i - 16];
      }
      compression.of(w);
    }
    return compression.digest;
  }

  // Set of logical functions as defined by the RFC6234.
  // Note: w64 => unsinged 64-bit word.
  static int _ssig0(int w64) => _rotr64(w64, 1) ^ _rotr64(w64, 8) ^ (w64 >>> 7);
  static int _ssig1(int w64) =>
      _rotr64(w64, 19) ^ _rotr64(w64, 61) ^ (w64 >>> 6);
}

/// Factory of [_Compr].
class _ComprFactory implements Scalar<_Compr> {
  /// Compression for SHA384
  ///
  /// Sets the initial hash values as the first 64 bits of the fractional parts
  /// of the square roots of the ninth through sixteenth prime numbers.
  const _ComprFactory.sha384() : this._set(_sha384InitHash);

  /// Compression for SHA512
  ///
  /// Sets the initial hash values as the first 64 bits of the fractional parts
  /// of the square roots of the first eight prime numbers.
  const _ComprFactory.sha512() : this._set(_sha512InitHash);

  /// Sets the initial hash values.
  const _ComprFactory._set(this._initHash);

  final List<int> _initHash;

  /// Makes a new [_Compr] instance.
  @override
  _Compr call() => _Compr.init(_initHash);

  // Initial hash values for Sha384
  //
  // the first 64 bits of the fractional parts of the square roots of the ninth
  // through sixteenth prime numbers.
  static const _sha384InitHash = [
    0xcbbb9d5dc1059ed8, // h0
    0x629a292a367cd507, // h1
    0x9159015a3070dd17, // h2
    0x152fecd8f70e5939, // h3
    0x67332667ffc00b31, // h4
    0x8eb44a8768581511, // h5
    0xdb0c2e0d64f98fa7, // h6
    0x47b5481dbefa4fa4, // h7
  ];
  // Initial hash values for Sha512
  //
  // The first 64 bits of the fractional parts of the square roots of the first
  // eight prime numbers.
  static const _sha512InitHash = [
    0x6a09e667f3bcc908, // h0
    0xbb67ae8584caa73b, // h1
    0x3c6ef372fe94f82b, // h2
    0xa54ff53a5f1d36f1, // h3
    0x510e527fade682d1, // h4
    0x9b05688c2b3e6c1f, // h5
    0x1f83d9abfb41bd6b, // h6
    0x5be0cd19137e2179, // h7
  ];
}

/// Compression.
///
/// A one-way compression function is a function that transforms two
/// fixed-length inputs into a fixed-length output.
///
/// Inputs: message schedule array and the initial hash array.
/// Output: the digest (hash) value of the input message.
class _Compr {
  /// Sets the initial hash values.
  const _Compr(Uint64List hash)
      : assert(hash.length == 8),
        _hash = hash;

  /// Sets the initial hash values with an 8-element list.
  _Compr.init(List<int> init) : this(Uint64List.fromList(init));

  // Set of logical functions as defined by the RCF6234.
  // Note: w64 => unsinged 64-bit word.
  static int _bsig0(int w64) =>
      _rotr64(w64, 28) ^ _rotr64(w64, 34) ^ _rotr64(w64, 39);
  static int _bsig1(int w64) =>
      _rotr64(w64, 14) ^ _rotr64(w64, 18) ^ _rotr64(w64, 41);
  static int _ch(int x, int y, int z) => (x & y) ^ ((~x) & z);
  static int _maj(int x, int y, int z) => (x & y) ^ (x & z) ^ (y & z);

  /// Compression of [w] words.
  void of(Uint64List w) {
    // Initialize variables a, b, c, d, e, f, g, h and set them equal to the
    // current hash values respectively h0, h1, h2, h3, h4, h5, h6, h7.
    var a = _hash[0];
    var b = _hash[1];
    var c = _hash[2];
    var d = _hash[3];
    var e = _hash[4];
    var f = _hash[5];
    var g = _hash[6];
    var h = _hash[7];

    for (var i = 0; i < 80; ++i) {
      final temp1 = h + _bsig1(e) + _ch(e, f, g) + _rounds[i] + w[i];
      final temp2 = _bsig0(a) + _maj(a, b, c);
      h = g;
      g = f;
      f = e;
      e = d + temp1;
      d = c;
      c = b;
      b = a;
      a = temp1 + temp2;
    }
    // Add the compressed chunk to the current hash value.
    _hash[0] += a;
    _hash[1] += b;
    _hash[2] += c;
    _hash[3] += d;
    _hash[4] += e;
    _hash[5] += f;
    _hash[6] += g;
    _hash[7] += h;
  }

  /// The digest bytes of the current hash value.
  Uint8List get digest {
    // ByteData used to avoid endianness errors.
    final data = ByteData(64);
    SetUint64.big(data)
      ..value(0, _hash[0])
      ..value(8, _hash[1])
      ..value(16, _hash[2])
      ..value(24, _hash[3])
      ..value(32, _hash[4])
      ..value(40, _hash[5])
      ..value(48, _hash[6])
      ..value(56, _hash[7]);
    return data.buffer.asUint8List();
  }

  final Uint64List _hash;

  /// The array of round constants _K_.
  ///
  /// SHA-384 and SHA-512 use the same sequence of eighty constant 64-bit words,
  /// K0, K1, … , K79.  These words represent the first 64 bits of the
  /// fractional parts of the cube roots of the first eighty prime numbers.
  static const _rounds = [
    0x428a2f98d728ae22, // K0
    0x7137449123ef65cd, // K1
    0xb5c0fbcfec4d3b2f, // K2
    0xe9b5dba58189dbbc, // K3
    0x3956c25bf348b538, // K4
    0x59f111f1b605d019, // K5
    0x923f82a4af194f9b, // K6
    0xab1c5ed5da6d8118, // K7
    0xd807aa98a3030242, // K8
    0x12835b0145706fbe, // K9
    0x243185be4ee4b28c, // K10
    0x550c7dc3d5ffb4e2, // K11
    0x72be5d74f27b896f, // K12
    0x80deb1fe3b1696b1, // K13
    0x9bdc06a725c71235, // K14
    0xc19bf174cf692694, // K15
    0xe49b69c19ef14ad2, // K16
    0xefbe4786384f25e3, // K17
    0x0fc19dc68b8cd5b5, // K18
    0x240ca1cc77ac9c65, // K19
    0x2de92c6f592b0275, // K20
    0x4a7484aa6ea6e483, // K21
    0x5cb0a9dcbd41fbd4, // K22
    0x76f988da831153b5, // K23
    0x983e5152ee66dfab, // K24
    0xa831c66d2db43210, // K25
    0xb00327c898fb213f, // K26
    0xbf597fc7beef0ee4, // K27
    0xc6e00bf33da88fc2, // K28
    0xd5a79147930aa725, // K29
    0x06ca6351e003826f, // K30
    0x142929670a0e6e70, // K31
    0x27b70a8546d22ffc, // K32
    0x2e1b21385c26c926, // K33
    0x4d2c6dfc5ac42aed, // K34
    0x53380d139d95b3df, // K35
    0x650a73548baf63de, // K36
    0x766a0abb3c77b2a8, // K37
    0x81c2c92e47edaee6, // K38
    0x92722c851482353b, // K39
    0xa2bfe8a14cf10364, // K40
    0xa81a664bbc423001, // K41
    0xc24b8b70d0f89791, // K42
    0xc76c51a30654be30, // K43
    0xd192e819d6ef5218, // K44
    0xd69906245565a910, // K45
    0xf40e35855771202a, // K46
    0x106aa07032bbd1b8, // K47
    0x19a4c116b8d2d0c8, // K48
    0x1e376c085141ab53, // K49
    0x2748774cdf8eeb99, // K50
    0x34b0bcb5e19b48a8, // K51
    0x391c0cb3c5c95a63, // K52
    0x4ed8aa4ae3418acb, // K53
    0x5b9cca4f7763e373, // K54
    0x682e6ff3d6b2b8a3, // K55
    0x748f82ee5defb2fc, // K56
    0x78a5636f43172f60, // K57
    0x84c87814a1f0ab72, // K58
    0x8cc702081a6439ec, // K59
    0x90befffa23631e28, // K60
    0xa4506cebde82bde9, // K61
    0xbef9a3f7b2c67915, // K62
    0xc67178f2e372532b, // K63
    0xca273eceea26619c, // K64
    0xd186b8c721c0c207, // K65
    0xeada7dd6cde0eb1e, // K66
    0xf57d4f7fee6ed178, // K67
    0x06f067aa72176fba, // K68
    0x0a637dc5a2c898a6, // K69
    0x113f9804bef90dae, // K70
    0x1b710b35131c471b, // K71
    0x28db77f523047d84, // K72
    0x32caab7b40c72493, // K73
    0x3c9ebe0a15c9bebc, // K74
    0x431d67c49c100d4c, // K75
    0x4cc5d4becb3e42b6, // K76
    0x597f299cfc657e2a, // K77
    0x5fcb6fab3ad6faec, // K78
    0x6c44198c4a475817, // K79
  ];
}

/// General information about bit padding.
class _PadInfo {
  /// Encapsulates the input bytes of the original message.
  const _PadInfo(this._input);

  /// The original bytes.
  final Uint8List _input;

  /// The length in bits of the original message.
  int get _lengthInBits => _input.lengthInBytes * 8;

  /// The natural number 'M' to always keep the expression 'L + 1 + K + 128' a
  /// positive multiple of 1024 bits. Ex: L + 1 + 128 + K = 1024 * M, where M is
  /// a natural number >= 1.
  ///
  /// Since the minimum amount of addressable data is one byte (group of 8
  /// bits), all calculations are performed in number of bytes instead of bits.
  /// Thus, 'M' will be an integer value such that the above expression will
  /// always result in a multiple of 128 bytes (1024 bits).
  // int get _m => ((_input.lengthInBytes + 1 + 16) / 128).ceil();
  int get _m => ((_input.lengthInBytes + 17) / 128).ceil();

  /// The number of bytes containing padding '0's (zeroes).
  ///
  /// K, the number of '0's to be appended.
  /// L, the length (in bits) of the original message.
  /// Retrieves K such that L + 1 + K + 128 is a multiple of 1024 bits; in other
  /// words, K is the smallest, non-negative solution to the equation:
  ///   ( L + 1 + K ) mod 1024 = 896
  ///
  /// The result is at least 1 due to the single '1' padding bit.
  // int get _numOfPadBytes => 1 + ((128 * _m) - _input.lengthInBytes - 1 - 16);
  int get _numOfPadBytes => 1 + ((128 * _m) - _input.lengthInBytes - 17);

  /// A list of a single '1' bit followed by the padding '0's.
  ///
  /// It will pad with '0’s until the data is a multiple of 1024 less 128 bits.
  Uint8List get padding => Uint8List(_numOfPadBytes)..[0] = 0x80; // 10000000

  /// The original message length (L) as a 128-bit (16-byte) big-endian value.
  Uint8List get lengthBigEndian {
    final length128bits = ByteData(16);
    SetUint64.big(length128bits)
      ..value(0, 0) // the higher 64 bits
      ..value(8, _lengthInBits); // the lower 64 bits
    return length128bits.buffer.asUint8List();
  }
}
