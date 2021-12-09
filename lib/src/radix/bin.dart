import 'dart:typed_data';

import '../../bit.dart';
import 'radix.dart';

/// Binary text of n-bit words with padding '0's.
const bin = Bin();

/// Binary text of n-bit words without padding '0's.
const binNoPad = Bin.noPad();

/// Binary text of 8-bit words
const bin8 = Bin.w8();

/// Binary text of 16-bit words
const bin16 = Bin.w16();

/// Binary text of 32-bit words
const bin32 = Bin.w32();

/// Binary text of 64-bit words
const bin64 = Bin.w64();

/// Binary text representation of n-bit words.
///
/// Normally, the characters '0' and '1' are suitable for most cases; however,
/// in some special circumstances, it may be desirable to use different symbols,
/// such as a 't' and 'f' for 'true' and 'false'; an 'h' and 'l' for 'high' and
/// 'low'; 'O' and 'X' for tic-tac-toe symbols. You can change the binary
/// symbols by setting the constructor parameter _codeUnits_ with custom
/// symbols.
class Bin implements BitsAsText {
  /// Binary text of n-bit words — the default digits are _0_ and _1_.
  ///
  /// Examples:
  /// - a 4-bit word whose value is 1 => 0001
  /// - a 8-bit word whose value is 15 => 00001111.
  ///
  /// If you do not want padding '0's, see [Bin.noPad].
  ///
  /// Characters To Represent Binary Digits
  ///
  /// The [codeUnits] parameter is a two-element list that defines the
  /// characters to be used. Each element is an UTF-8 encoded byte. For example,
  /// if the first element is _0x30_ (unicode for '0'), then bits whose value is
  /// 0 will be printed as '0'; similiarly, if the second element is _0x31_
  /// (unicode for '1'), then bits whose value is 1 will be printed as '1'.
  ///
  /// See also:
  /// - [list of unicode characters](https://en.wikipedia.org/wiki/List_of_Unicode_characters)
  ///
  /// Computing The Number of Bits
  ///
  /// If the [bitLen] instance returns a bit length greater than the necessary,
  /// the generated binary text will be filled with padding '0's on the left. As
  /// a result, if a _word_ value is 12 (twelve in decimal), and [bitLen]
  /// returns 8 (which means an eight-bit wide word), the generated binary text
  /// will be '00001100' (note the leading four '0's); on the other hand, had
  /// [binLen] returned 16, then the generated text would have been
  /// '0000000000001100'; finally, if [binLen] returns a number that is less
  /// than necessary, the value will be truncated. For example, if the word
  /// value in decimal is 15, and the word length is 2 bits, then instead of
  /// '1111', the generated text will be '11' (3 in decimal).
  const Bin({
    BitLen bitLen = const FixBitLen(),
    List<int> codeUnits = _zeroOne,
  })  : _bitLen = bitLen,
        _codeUnits = codeUnits;

  /// Binary text of n-bit words without padding '0's.
  ///
  /// Examples: 0x01 => '1'; 0x02 => '10'; 0x04 => '100'; 0x08 => '1000'; 0x44 =>
  /// '1000100'.
  const Bin.noPad() : this(bitLen: const MinBitLen(), codeUnits: _zeroOne);

  /// Binary text of 8-bit words — the default digits are '0' and '1'.
  ///
  /// Examples: 0x33 => '00110011'; 0x01 => '0000001'.
  const Bin.w8({List<int> codeUnits = _zeroOne})
      : this(bitLen: const FixBitLen.w8(), codeUnits: codeUnits);

  /// Binary text of 16-bit words — the default digits are '0' and '1'.
  ///
  /// Example: 0xff => '0000000011111111'.
  const Bin.w16({List<int> codeUnits = _zeroOne})
      : this(bitLen: const FixBitLen.w16(), codeUnits: codeUnits);

  /// Binary text of 32-bit words — the default digits are '0' and '1'.
  ///
  /// Example: 0xff => '00000000000000000000000011111111'.
  const Bin.w32({List<int> codeUnits = _zeroOne})
      : this(bitLen: const FixBitLen.w32(), codeUnits: codeUnits);

  /// Binary text of 64-bit words — the default digits are '0' and '1'.
  ///
  /// Example: 0xff =>
  /// '0000000000000000000000000000000000000000000000000000000011111111'.
  const Bin.w64({List<int> codeUnits = _zeroOne})
      : this(bitLen: const FixBitLen.w64(), codeUnits: codeUnits);

  // Retrieves the number of bits to represent n-bit words in binary.
  final BitLen _bitLen;
  // The source of characters.
  final List<int> _codeUnits;

  // Retrieves a binary text representation of [word].
  @override
  String call(int word) {
    assert(_codeUnits.length == 2);
    var bits = word;
    final binCodes = Uint8List(_bitLen(bits));
    final last = binCodes.length - 1;
    for (var pos = last; pos >= 0; --pos) {
      final ind = bits & 0x01;
      binCodes[pos] = _codeUnits[ind];
      bits >>>= 1;
    }
    return String.fromCharCodes(binCodes);
  }

  /// Unicode of 2 binary values '0' and '1'.
  static const List<int> _zeroOne = [0x30, 0x31];
}
