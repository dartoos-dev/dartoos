import 'dart:typed_data';

import '../bit/mor.dart';
import 'radix.dart';
import 'uint_dig_len.dart';
import 'uint_dig_len_oper.dart';

/// Unsigned int text of n-bit words with padding '0's.
const uint = Uint();

/// Unsigned int text of n-bit words without padding '0's.
const uintNoPad = Uint.noPad();

/// Unsigned int text of 8-bit words.
const uint8 = Uint.w8();

/// Unsigned int text of 16-bit words.
const uint16 = Uint.w16();

/// Unsigned int text of 32-bit words.
const uint32 = Uint.w32();

/// Unsigned int text of 64-bit words.
const uint64 = Uint.w64();

/// Text representation of unsigned integer values.
///
/// By default, the digits [0–9] are used as the decimal symbols. Normally,
/// these characters are suitable for most cases; however, in some special
/// circumstances, it may be desirable to use different symbols. You can change
/// the decimal symbols by setting the constructor parameter _codeUnits_ with
/// custom symbols.
class Uint implements BitsAsText {
  /// Unsigned integer text of n-bit words.
  ///
  /// [codeUnits] is a fixed 10-element list for setting the characters to be
  /// used. Each element is a UTF-8 encoded byte. The order of the elements
  /// determines which symbol represents a decimal digit. For example, if the
  /// first element is _0x30_ (unicode for '0'), then the value _0_ (zero) will
  /// be printed as '0'; likewise, if the second element is _0x31_ (unicode for
  /// '1'), then the value _1_ (one) will be printed as '1'; finally, if the
  /// last element is _0x39_ (unicode for '9'), then the value _9_ (nine) will
  /// be printed as '9'.
  ///
  /// In summary: each digit of a word is used as an index in the decimal symbol
  /// lookup table.
  ///
  /// See also:
  /// - [list of unicode characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters)
  ///
  /// [uintDigLen] is the [DigLen] instance that retrieves the number of
  /// integers digits required to represent _n-bit words_. If it returns a value
  /// that is greater than the necessary, the generated decimal text will be
  /// filled with padding '0's on the left. As a result, if a _word_ value is 7
  /// and [uintDigLen] returns 2, the generated text will be '07' (note the
  /// leading '0'); on the other hand, had [uintDigLen] returned 3, the
  /// generated text would have been '007'. However, if [uintDigLen] returns a
  /// value that is less than the necessary, the generated text will be
  /// truncated. For example, if a _word_ is 1234 and [uintDigLen] returns 3,
  /// the generated text will be '234'(note the missing '1').
  const Uint({
    DigLen uintDigLen = const UintDigLen(),
    List<int> codeUnits = _decSymbols,
  })  : _uintDigLen = uintDigLen,
        _codeUnits = codeUnits;

  /// The minimum unsigned integer text to represent n-bit _words_ — no padding
  /// '0's.
  ///
  /// The total length of the generated decimal string will be the minimum
  /// required to represent _word_ as a text of decimal values. For example, if
  /// _word_ contains the value _6_, a single dec digit '6' will be generated.
  const Uint.noPad({List<int> codeUnits = _decSymbols})
      : this(uintDigLen: const UintDigLen(), codeUnits: codeUnits);

  /// Unsigned integer text of 8-bit words — default symbols are [0–9].
  const Uint.w8({List<int> codeUnits = _decSymbols})
      : this(
          uintDigLen: const UintDigLenOper.w8(MOr.w8()),
          codeUnits: codeUnits,
        );

  /// Unsigned integer text of 16-bit words — default symbols are [0–9].
  const Uint.w16({List<int> codeUnits = _decSymbols})
      : this(
          uintDigLen: const UintDigLenOper.w16(MOr.w16()),
          codeUnits: codeUnits,
        );

  /// Unsigned integer text of 32-bit words — default symbols are [0–9].
  const Uint.w32({List<int> codeUnits = _decSymbols})
      : this(
          uintDigLen: const UintDigLenOper.w32(MOr.w32()),
          codeUnits: codeUnits,
        );

  /// Unsigned integer text of 64-bit words — default symbols are [0–9].
  const Uint.w64({List<int> codeUnits = _decSymbols})
      : this(
          uintDigLen: const UintDigLenOper.w64(MOr.w64()),
          codeUnits: codeUnits,
        );

  // Retrieves the number of digits.
  final DigLen _uintDigLen;
  // The source of decimal characters.
  final List<int> _codeUnits;

  /// The text representation of [word] as an unsigned integer value.
  @override
  String call(int word) {
    final Uint8List uintCodes = Uint8List(_uintDigLen(word));
    var decimal = word;
    final last = uintCodes.length - 1;
    for (var pos = last; pos >= 0; --pos) {
      final ind = decimal % 10;
      uintCodes[pos] = _codeUnits[ind];
      decimal ~/= 10;
    }
    return String.fromCharCodes(uintCodes);
  }

  /// Unicodes of the ten decimal symbols.
  static const _decSymbols = [
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
  ];
}
