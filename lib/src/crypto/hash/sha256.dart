import 'dart:typed_data';

import 'package:dartoos/bit.dart';
import 'package:dartoos/crypto.dart';
import 'package:dartoos/func.dart';

/// SHA-256 hash function.
///
/// Its output (message digest) size is 256 bits (32 bytes).
///
/// See also:
///
/// - [RFC 6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.1)
const HashByte sha256 = _Sha256();

/// SHA-224 hash function.
///
/// Its a truncated version of [sha256] with different initial hash values.
///
/// See also:
///
/// - [RFC 6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.1)
const HashByte sha224 = _Sha224();

/// The SHA-256 variant of the SHA-2 family (Secure Hash Algorithm 2).
///
/// [RFC6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.1)
class _Sha256 with ChunksOf64Bytes {
  /// SHA-256 cryptographic hash function.
  const _Sha256();

  /// Retrieves the 256-bit hash value (digest) of [input].
  @override
  Uint8List call(Uint8List input) => _digest256(input);

  static const _digest256 = _Padding(_MsgSched(_ComprFactory.sha256()));
}

/// The SHA-224 variant of the SHA-2 family (Secure Hash Algorithm 2).
///
/// [RFC6234](https://datatracker.ietf.org/doc/html/rfc6234#section-5.1)
class _Sha224 with ChunksOf64Bytes {
  /// SHA-224 cryptographic hash function.
  const _Sha224();

  /// Retrieves the 224-bit hash value (digest) of [input].
  @override
  Uint8List call(Uint8List input) =>
      _digest224(input).buffer.asUint8List(0, 28);

  static const _digest224 = _Padding(_MsgSched(_ComprFactory.sha224()));
}

/// The padding stage.
///
/// The purpose of message padding is to make the total length of a padded
/// message a multiple of 256 bits.
///
/// Padding:
/// - 1. begin with the original message of length L bits and append a single
///      '1' bit.
/// - 2. append K '0's, where K is the minimum number >= 0 such that L + 1 + K +
///      64 is a multiple of 512.
/// - 3. append L as a 64-bit big-endian integer, making the total
///      post-processed length a multiple of 512 bits such that the bits in the
///      message are
///      L 1 00..<K 0's>..00 <L as 64 bit integer> = k*512 total bits.
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
/// Since L = 40, the number of bits in the above is 41 and K = 407 "0"s are
/// appended, making the total now 448. This gives the following in hex:
///
///   _61626364 65800000 00000000 00000000_
///   _00000000 00000000 00000000 00000000_
///   _00000000 00000000 00000000 00000000_
///   _00000000 00000000_
///
/// The 64-bit representation of L = 40 is hex 00000000 00000028. Hence the
/// final padded message is the following hex
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
  /// total of K '0' bits until L + K + 64 is a multiple of 512. The
  /// post-processed length of [input] is a multiple of 512.
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

// Performs rotate-right operations on 32-bit words.
const _rotr32 = Rotr.w32();

/// Process the message in successive chunks.
class _MsgSched {
  /// Sets the factory of [_Compr] instances.
  const _MsgSched(this._toCompr);

  /// A factory of [_Compr] instances.
  final Scalar<_Compr> _toCompr;

  static const _bytesPerWord = 4;
  static const _bytesPerChunck = 64;

  // A [ByteData] instance is used to prevent endianness errors.
  Uint8List call(ByteData message) {
    // The length of the input message must always be a multiple of 64 bytes
    // (512 bits).
    assert(message.lengthInBytes % _bytesPerChunck == 0);
    final compression = _toCompr();
    // Message Schedule (w) of sixty-four 32-bit words w[0…63].
    final w = Uint32List(64);

    /// Each 512-bit (64 bytes) chunk of data from input are composed of sixteen
    /// 32-bit words M(i)0, M(i)1, …, M(i)15.
    final total = message.lengthInBytes;
    // For each chunck of 64 bytes, perform...
    for (var chunck = 0; chunck < total; chunck += _bytesPerChunck) {
      // Copy chunck into first 16 words w[0..15] of the message schedule array
      for (var i = 0; i < 16; ++i) {
        final offset = (i * _bytesPerWord) + chunck;
        w[i] = message.getUint32(offset);
      }
      // Extend the first 16 words into the remaining 48 words w[16..63] of the
      // message schedule array
      for (var i = 16; i < 64; ++i) {
        w[i] = _ssig1(w[i - 2]) + w[i - 7] + _ssig0(w[i - 15]) + w[i - 16];
      }
      compression.of(w);
    }
    return compression.digest;
  }

  // Logical functions as defined by the RFC6234.
  // w32 => unsinged 32-bit word.
  static int _ssig0(int w32) =>
      _rotr32(w32, 7) ^ _rotr32(w32, 18) ^ (w32 >>> 3);
  static int _ssig1(int w32) =>
      _rotr32(w32, 17) ^ _rotr32(w32, 19) ^ (w32 >>> 10);
}

/// Factory of [_Compr].
class _ComprFactory implements Scalar<_Compr> {
  /// Compression for SHA224
  ///
  /// Sets the initial hash values as the the second 32 bits of the fractional
  /// parts of the square roots of the 9th through 16th primes 23..53
  const _ComprFactory.sha224() : this._set(_sha224InitHash);

  /// Compression for SHA256
  ///
  /// Sets the initial hash values as the first 32 bits of the fractional parts
  /// of the square roots of the first 8 primes: 2, 3, 5, 7, 11, 13, 17, 19.
  const _ComprFactory.sha256() : this._set(_sha256InitHash);

  /// Sets the initial hash values.
  const _ComprFactory._set(this._initHash);

  final List<int> _initHash;

  /// Makes a new [_Compr] instance.
  @override
  _Compr call() => _Compr.init(_initHash);

  // Initial hash values for Sha224
  static const _sha224InitHash = [
    0xc1059ed8, // h0
    0x367cd507, // h1
    0x3070dd17, // h2
    0xf70e5939, // h3
    0xffc00b31, // h4
    0x68581511, // h5
    0x64f98fa7, // h6
    0xbefa4fa4, // h7
  ];
  // Initial hash values for Sha256
  static const _sha256InitHash = [
    0x6a09e667, // h0
    0xbb67ae85, // h1
    0x3c6ef372, // h2
    0xa54ff53a, // h3
    0x510e527f, // h4
    0x9b05688c, // h5
    0x1f83d9ab, // h6
    0x5be0cd19, // h7
  ];
}

/// The Compression Phase
///
/// A one-way compression function is a function that transforms two
/// fixed-length inputs into a fixed-length output.
///
/// Inputs: word message and the hash array.
/// Output: the digest (hash) value of the input message.
class _Compr {
  /// Sets the initial hash values.
  const _Compr(Uint32List hash)
      : assert(hash.length == 8),
        _hash = hash;

  /// Sets the initial hash values with an 8-element list.
  _Compr.init(List<int> init) : this(Uint32List.fromList(init));

  // Set of logical functions as defined by the RCF6234.
  // Note: w32 => unsinged 32-bit word.
  static int _bsig0(int w32) =>
      _rotr32(w32, 2) ^ _rotr32(w32, 13) ^ _rotr32(w32, 22);
  static int _bsig1(int w32) =>
      _rotr32(w32, 6) ^ _rotr32(w32, 11) ^ _rotr32(w32, 25);
  static int _ch(int x, int y, int z) => (x & y) ^ ((~x) & z);
  static int _maj(int x, int y, int z) => (x & y) ^ (x & z) ^ (y & z);

  /// Compression of [w] words.
  void of(Uint32List w) {
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

    for (var i = 0; i < 64; ++i) {
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
    return (ByteData(32)
          ..setUint32(0, _hash[0])
          ..setUint32(4, _hash[1])
          ..setUint32(8, _hash[2])
          ..setUint32(12, _hash[3])
          ..setUint32(16, _hash[4])
          ..setUint32(20, _hash[5])
          ..setUint32(24, _hash[6])
          ..setUint32(28, _hash[7]))
        .buffer
        .asUint8List();
  }

  final Uint32List _hash;

  /// The array of round constants.
  ///
  /// The first 32 bits of the fractional parts of the cube roots of the first
  /// 64 primes 2–311
  static const _rounds = [
    0x428a2f98, // k0
    0x71374491, // k1
    0xb5c0fbcf, // k2
    0xe9b5dba5, // k3
    0x3956c25b, // k4
    0x59f111f1, // k5
    0x923f82a4, // k6
    0xab1c5ed5, // k7
    0xd807aa98, // k8
    0x12835b01, // k9
    0x243185be, // k10
    0x550c7dc3, // k11
    0x72be5d74, // k12
    0x80deb1fe, // k13
    0x9bdc06a7, // k14
    0xc19bf174, // k15
    0xe49b69c1, // k16
    0xefbe4786, // k17
    0x0fc19dc6, // k18
    0x240ca1cc, // k19
    0x2de92c6f, // k20
    0x4a7484aa, // k21
    0x5cb0a9dc, // k22
    0x76f988da, // k23
    0x983e5152, // k24
    0xa831c66d, // k25
    0xb00327c8, // k26
    0xbf597fc7, // k27
    0xc6e00bf3, // k28
    0xd5a79147, // k29
    0x06ca6351, // k30
    0x14292967, // k31
    0x27b70a85, // k32
    0x2e1b2138, // k33
    0x4d2c6dfc, // k34
    0x53380d13, // k35
    0x650a7354, // k36
    0x766a0abb, // k37
    0x81c2c92e, // k38
    0x92722c85, // k39
    0xa2bfe8a1, // k40
    0xa81a664b, // k41
    0xc24b8b70, // k42
    0xc76c51a3, // k43
    0xd192e819, // k44
    0xd6990624, // k45
    0xf40e3585, // k46
    0x106aa070, // k47
    0x19a4c116, // k48
    0x1e376c08, // k49
    0x2748774c, // k50
    0x34b0bcb5, // k51
    0x391c0cb3, // k52
    0x4ed8aa4a, // k53
    0x5b9cca4f, // k54
    0x682e6ff3, // k55
    0x748f82ee, // k56
    0x78a5636f, // k57
    0x84c87814, // k58
    0x8cc70208, // k59
    0x90befffa, // k60
    0xa4506ceb, // k61
    0xbef9a3f7, // k62
    0xc67178f2, // k63
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

  /// The natural number 'M' to always keep the expression 'L + 1 + K + 64' a
  /// positive multiple of 512 bits. Ex: L + 1 + 64 + K = 512 * M, where M is a
  /// natural number >= 1.
  ///
  /// Since the minimum amount of addressable data is one byte (group of 8
  /// bits), all calculations are performed in number of bytes instead of bits.
  /// Thus, 'M' will be an integer value such that the above expression will
  /// always result in a multiple of 64 bytes (512 bits).
  // int get _m => ((_input.lengthInBytes + 1 + 8) / 64).ceil();
  int get _m => ((_input.lengthInBytes + 9) / 64).ceil();

  /// The number of bytes containing padding '0's (zeroes).
  ///
  /// K, the number of '0's to be appended.
  /// L, the length (in bits) of the original message.
  /// Retrieves K such that L + 1 + K + 64 is a multiple of 512 bits; in other
  /// words, K is the smallest, non-negative solution to the equation:
  ///   ( L + 1 + K ) mod 512 = 448
  ///
  /// The result is at least 1 due to the single '1' padding bit.
  // int get _numOfPadBytes => 1 + ((64 * _m) - _input.lengthInBytes - 1 - 8);
  int get _numOfPadBytes => 1 + ((64 * _m) - _input.lengthInBytes - 9);

  /// A list of a single '1' bit followed by the padding '0's.
  ///
  /// It will pad with '0’s until the data is a multiple of 512 less 64 bits.
  Uint8List get padding => Uint8List(_numOfPadBytes)..[0] = 0x80; // 10000000

  /// The original message length (L) as a 64-bit (8-byte) big-endian value.
  Uint8List get lengthBigEndian {
    return SetUint64.big(ByteData(8))
        .value(0, _lengthInBits)
        .buffer
        .asUint8List();
  }
}
