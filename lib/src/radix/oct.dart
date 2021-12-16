import 'dart:typed_data';

import 'package:dartoos/radix.dart';

/// Octal text of n-bit words with padding '0's.
const oct = Oct();

/// Octal text of n-bit words without padding '0's.
const octNoPad = Oct.noPad();

/// Octal text of 8-bit words
const oct8 = Oct.w8();

/// Octal text of 16-bit words
const oct16 = Oct.w16();

/// Octal text of 32-bit words
const oct32 = Oct.w32();

/// Octal text of 64-bit words
const oct64 = Oct.w64();

/// Octal text representation of n-bit words.
///
/// By default, the digits [0–7] are used as the octal symbols. Normally, these
/// characters are suitable for most cases; however, in some special
/// circumstances, it may be desirable to use different symbols. You can change
/// the octal symbols by setting the constructor parameter _codeUnits_ with
/// custom symbols.
class Oct implements BitsAsText {
  /// Octal text of n-bit words — the default octal symbols are [0–7].
  ///
  /// [codeUnits] is a fixed 8-element list that sets the characters to be used.
  /// Each element is a UTF-8 encoded byte. The order of the elements determines
  /// which symbol represents an octal digit. For example, if the first element
  /// is _0x30_ (unicode for '0'), it will represent groups of 3 bits whose
  /// value is _000₂_ (zero); likewise, if the second element is _0x31_ (unicode
  /// for '1'), it will represent groups of 3 bits whose value is _001₂_ (one);
  /// finally, if the last element is _0x37_ (unicode '7'), then it will
  /// represent groups of 3 bits whose value is _111₂_ (seven or _7₈_).
  ///
  /// In summary: each group of three consecutive bits of each word is used as
  /// an index in the octal symbol lookup table.
  ///
  /// See also:
  /// - [list of unicode characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters)
  ///
  /// Computing The Number of Bits
  ///
  /// If [octDigLen] returns a value that is greater than the necessary, the
  /// generated octal text will be filled with padding '0's on the left. As a
  /// result, if a _word_ is _7_ (seven in decimal), and [octDigLen] returns
  /// _6_, the generated octal text will be '07' (note the leading '0'); on the
  /// other hand, had [octDigLen] returned 9, the generated text would have been
  /// '007'. Finally, if [octDigLen] returns a non-multiple of three number, the
  /// printed value will be truncated. For example, if a word is 15, and
  /// [octDigLen] returns 2, then instead of '17', the generated octal text will
  /// be '3' ('11' in binary).
  const Oct({
    DigLen octDigLen = const OctDigLen(),
    List<int> codeUnits = _octSymbols,
  })  : _octDigLen = octDigLen,
        _codeUnits = codeUnits;

  /// The minimum octal text to represent n-bit words — no padding '0's.
  ///
  /// The total length of the generated octal string will be the minimum
  /// required to represent a _word_ as a text of octal values. For example, if
  /// a _word_ contains the value '6' (six in decimal), a single oct digit '6'
  /// will be generated.
  const Oct.noPad() : this(octDigLen: const OctDigLen());

  /// Octal text of 8-bit words — default octal symbols [0–7].
  const Oct.w8({List<int> codeUnits = _octSymbols})
      : this(octDigLen: const OctDigLen.w8(), codeUnits: codeUnits);

  /// Octal text of 16-bit words — default octal symbols [0–7].
  const Oct.w16({List<int> codeUnits = _octSymbols})
      : this(octDigLen: const OctDigLen.w16(), codeUnits: codeUnits);

  /// Octal text of 32-bit words — default octal symbols [0–7].
  const Oct.w32({List<int> codeUnits = _octSymbols})
      : this(octDigLen: const OctDigLen.w32(), codeUnits: codeUnits);

  /// Octal text of 64-bit words — default octal symbols [0–7].
  const Oct.w64({List<int> codeUnits = _octSymbols})
      : this(octDigLen: const OctDigLen.w64(), codeUnits: codeUnits);

  // The number of octal digits.
  final DigLen _octDigLen;
  // The source of octal characters.
  final List<int> _codeUnits;

  /// The octal text of [word].
  @override
  String call(int word) {
    final Uint8List octCodes = Uint8List(_octDigLen(word));
    var value = word;
    final last = octCodes.length - 1;
    for (var pos = last; pos >= 0; --pos) {
      final ind = value & 0x07; // value & 00000111
      octCodes[pos] = _codeUnits[ind];
      // 'value >>= 3' runs faster than 'value ~/= 8'.
      value >>>= 3;
    }
    return String.fromCharCodes(octCodes);
  }

  /// Unicode of the 7 octal symbols.
  static const _octSymbols = <int>[
    0x30, // '0'
    0x31, // '1'
    0x32, // '2'
    0x33, // '3'
    0x34, // '4'
    0x35, // '5'
    0x36, // '6'
    0x37, // '7'
  ];
}
