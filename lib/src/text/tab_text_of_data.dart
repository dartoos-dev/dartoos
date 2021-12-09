import 'dart:typed_data';

import '../func.dart';
import 'copy_char_codes.dart';
import 'sep.dart';
import 'tab_info_helper.dart';
import 'text.dart';

/// Tabular Text of Regular-Data Lists.
///
/// A Regular-data list is a list in which the length of the text representation
/// of its elements is the same; that is, if the first element has a
/// 15-character text representation, then all other elements will also have it.
///
/// For regular data, this class runs faster than [TabText].
///
/// Examples:
///
/// Given the values _0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08 0x09
/// 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F_:
///
/// - a four-column table/matrix of them in hexadecimal:
/// 00 01 02 03
/// 04 05 06 07
/// 08 09 0A 0B
/// 0C 0D 0E 0F
///
/// - a six-column table of them in hexadecimal:
/// 00 01 02 03 04 05
/// 06 07 08 09 0A 0B
/// 0C 0D 0E 0F
///
///  - edge case 1: a single-column table (all values end up in the column):
/// 00
/// 01
/// …
/// 0E
/// 0F
///
/// - edge case 2: there are fewer data elements than the specified number of
/// columns per row (all values end up in the row):
/// 00 01 02 03 04 05 06 07 08 09 0A 0B 0C 0D 0E 0F
class TabTextOfData implements ListAsText<int> {
  /// Constructs a tabular (matrix-formatted) text from regular data.
  ///
  /// [data] the original data to be transformed into a matrix-formatted text.
  /// [elemAsText] converts each data element into a text representation; if
  /// omitted, the method [toString] of the element will be invoked.
  /// [charPerElem] the number of text symbols for each data word.
  /// [colPerRow] the number of columns per row.
  /// [colSep] the column separator; if omitted, a single space ' ' will be used
  /// as the column separator.
  /// [rowSep] the row separator; if omitted, the new line character '\n' will
  /// be used as the row separator.
  const TabTextOfData({
    required int colPerRow,
    required int charPerElem,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
    Func<String, int> elemAsText = const ToStringOf<int>(),
  })  : _colPerRow = colPerRow,
        _charPerElem = charPerElem,
        _colSep = colSep,
        _rowSep = rowSep,
        _elemAsText = elemAsText;

  final Func<String, int> _elemAsText;
  final int _colPerRow;
  final int _charPerElem;
  final Sep _colSep;
  final Sep _rowSep;

  /// Returns [data] converted to text in tabular (matrix-like) format.
  @override
  String call(List<int> data) {
    // information related to the incoming data.
    final info = TabInfoHelper<int>(
      data,
      _elemAsText,
      charPerElem: _charPerElem,
      colPerRow: _colPerRow,
      colSep: _colSep,
      rowSep: _rowSep,
    );

    final codes = Uint8List(info.numOfCharCodes);
    final copy = CopyCharCodes(codes);
    var dataInd = 0; // the original data index.
    var column = 1; // current column
    while (copy.isNotFull) {
      copy(info.textAt(dataInd++));
      if (copy.isNotFull) {
        if (column < info.colPerRow) {
          copy(info.colSep); // column separator.
          ++column;
        } else {
          copy(info.rowSep); // line separator.
          column = 1; // restores the column to the initial position.
        }
      }
    }
    return String.fromCharCodes(codes);
  }
}
