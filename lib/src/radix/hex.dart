import 'dart:typed_data';

import 'package:dartoos/src/radix/radix.dart';

import 'hex_dig_len.dart';

/// Hex text of n-bit words with padding '0's.
const hex = Hex();

/// Hex text of n-bit words without padding '0's.
const hexNoPad = Hex.noPad();

/// Hex text of 8-bit words
const hex8 = Hex.w8();

/// Hex text of 16-bit words
const hex16 = Hex.w16();

/// Hex text of 32-bit words
const hex32 = Hex.w32();

/// Hex text of 64-bit words
const hex64 = Hex.w64();

/// Hexadecimal text representation of n-bit words.
///
/// By default, it uses the digits [0–9] and the lower-case letters [a–f] as the
/// hex symbols. Normally, these characters are suitable for most cases;
/// however, in some special circumstances, it may be desirable to use different
/// symbols. You can change the hexadecimal symbols by setting the constructor
/// parameter _codeUnits_ with custom symbols. Alternatively, if all you want is
/// the text in upper-case letters [A–F], use [Hex.upper].
class Hex implements BitsAsText {
  /// Hexadecimal text of [n]-bit words — the default hex symbols are [0–9a–f].
  ///
  /// [codeUnits] is a fixed 16-element list that sets the characters to be
  /// used. Each element is a pair of nibbles (a nibble is a group of 4 bits —
  /// half of a byte) that makes up an UTF-8 encoded byte. For example, if the
  /// first element is _0x30_ (unicode for '0'), it will represent nibbles whose
  /// value is _0000₂_ (zero); likewise, if the second element is _0x31_
  /// (unicode for '1'), it will represent nibbles whose value is _0001₂_ (one);
  /// finally, if the last element is _0x66_ (unicode 'f'), then it will
  /// represent nibbles whose value is _1111₂_ (_15_ in decimal; _f_ in hex).
  ///
  /// In summary: each nibble (group of four bits) of each word is used as an
  /// index in the hexadecimal symbol lookup table.
  ///
  /// See also:
  /// - [list of unicode characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters)
  ///
  /// Computing The Number of Bits
  ///
  /// [numOfHexDig] computes the number of hexadecimal digits to be used. If
  /// this numbers is greater than necessary, the generated text will be
  /// filled with padding '0's on the left. As a result, if a _word_ is 10 (ten
  /// in decimal), and [numOfHexDig] returns 2, then the text representation for
  /// the _word_ will be '0a' (note the leading '0'); on the other hand, had
  /// [numOfHexDig] returned 16, the generated text would have been '000a'.
  /// Finally, if [numOfHexDig] retrieves a number that is not a multiple of
  /// four, the hexadecimal text will represent a truncated value of the given
  /// _word_. For instance, if the word value in decimal is 15 ('f' in hex;
  /// '1111' in binary), and the number of hex digits is 1, the hexadecimal
  /// digit will be '3' ('11' in binary) rather than 'f'.
  ///
  /// [hexDigLen] calculates the number of hexadecimal digits to be used. If
  /// this number is greater than necessary, the generated text will be filled
  /// with padding '0's. For instance, if a _word_ value is 10 (ten in decimal)
  /// and [hexDigLen] returns 2, the text representation for the _word_ will be
  /// '0a' (note the initial '0'); on the other hand, if [hexDigLen] returned
  /// 16, the generated text would be '000a'. Finally, if [hexDigLen] retrieves
  /// a number that is not a multiple of four, the hexadecimal text will be a
  /// truncated value of the given _word_. For example, if the word value in
  /// decimal is 15 ('f' in hex; '1111' in binary) and the number of hexadecimal
  /// digits is 1, the hexadecimal digit will be '3' ('11' in binary) instead of
  /// 'f'.
  ///
  /// For texts without padding characters (leading '0's), see [Hex.noPad].
  const Hex({
    DigLen hexDigLen = const HexDigLen(),
    List<int> codeUnits = _lowercaseHex,
  })  : _hexDigLen = hexDigLen,
        _codeUnits = codeUnits;

  /// Uppercase hexadecimal text of [n]-bit words — hex symbols [0–9A–F].
  const Hex.upper() : this(codeUnits: _uppercaseHex);

  /// The minimum hexadecimal text to represent n-bit words — no padding '0's.
  ///
  /// The total length of the generated hex string will be the minimum required
  /// to represent the word as a hex text. For example, if a _word_ contains the
  /// value '12' (twelve in decimal), a single hex digit 'c' will be generated.
  ///
  /// The default hex symbols are [0–9a–f].
  const Hex.noPad({List<int> codeUnits = _lowercaseHex})
      : this(hexDigLen: const HexDigLen(), codeUnits: codeUnits);

  /// The uppercase version of [Hex.noPad] — hex symbols [0–9A–F].
  const Hex.upperNoPad() : this.noPad(codeUnits: _uppercaseHex);

  /// The hexadecimal digits of 8-bit words — default hex symbols [0–9a–f].
  const Hex.w8({List<int> codeUnits = _lowercaseHex})
      : this(hexDigLen: const HexDigLen.w8(), codeUnits: codeUnits);

  /// The uppercase hexadecimal digits of 8-bit words — hex symbols [0–9A–F].
  const Hex.upperw8() : this.w8(codeUnits: _uppercaseHex);

  /// The hexadecimal digits of 16-bit words — default hex symbols [0–9a–f].
  const Hex.w16({List<int> codeUnits = _lowercaseHex})
      : this(hexDigLen: const HexDigLen.w16(), codeUnits: codeUnits);

  /// The uppercase hexadeciaml digits of 16-bit words — hex symbols [0–9A–F].
  const Hex.upperw16() : this.w16(codeUnits: _uppercaseHex);

  /// The hexadecimal digits of 32-bit words — default hex symbols [0–9a–f].
  const Hex.w32({List<int> codeUnits = _lowercaseHex})
      : this(hexDigLen: const HexDigLen.w32(), codeUnits: codeUnits);

  /// The uppercase version of [Hex.w32] — hex symbols [0–9A–F].
  const Hex.upperw32() : this.w32(codeUnits: _uppercaseHex);

  /// The hexadecimal digits of 64-bit words — default hex symbols [0–9a–f].
  const Hex.w64({List<int> codeUnits = _lowercaseHex})
      : this(hexDigLen: const HexDigLen.w64(), codeUnits: codeUnits);

  /// The uppercase hexadecimal digits of 64-bit words — hex symbols [0–9A–F].
  const Hex.upperw64() : this.w64(codeUnits: _uppercaseHex);

  // The number of hexadecimal digits for a given n-bit word.
  final DigLen _hexDigLen;
  // The source of characters.
  final List<int> _codeUnits;

  /// The hexadecimal text of [word].
  @override
  String call(int word) {
    final Uint8List hexCodes = Uint8List(_hexDigLen(word));
    var value = word;
    final last = hexCodes.length - 1;
    for (var count = last; count >= 0; --count) {
      final ind = value & 0x0f; // each nibble is an index.
      hexCodes[count] = _codeUnits[ind];
      // 'value >>>= 4' runs faster than the equivalent command 'value ~/= 16'.
      value >>>= 4;
    }
    return String.fromCharCodes(hexCodes);
  }

  /// Unicode lowercase hex charactes [0–9a–f].
  static const _lowercaseHex = <int>[
    0x30, // '0'
    0x31, // '1'
    0x32, // '2'
    0x33, // '3'
    0x34, // '4'
    0x35, // '5'
    0x36, // '6'
    0x37, // '7'
    0x38, // '8'
    0x39, // '9'
    0x61, // 'a'
    0x62, // 'b'
    0x63, // 'c'
    0x64, // 'd'
    0x65, // 'e'
    0x66, // 'f'
  ];

  /// Unicode Uppercase Hexadecimal Charactes [0–9A–F].
  static const _uppercaseHex = <int>[
    0x30, // '0'
    0x31, // '1'
    0x32, // '2'
    0x33, // '3'
    0x34, // '4'
    0x35, // '5'
    0x36, // '6'
    0x37, // '7'
    0x38, // '8'
    0x39, // '9'
    0x41, // 'A'
    0x42, // 'B'
    0x43, // 'C'
    0x44, // 'D'
    0x45, // 'E'
    0x46, // 'F'
  ];
}
