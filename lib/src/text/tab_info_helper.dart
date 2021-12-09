import '../func.dart';
import 'sep.dart';

/// Helper class that retrieves information about the data to be transformed
/// into a tabular text.
class TabInfoHelper<T> {
  /// Ctor.
  const TabInfoHelper(
    List<T> data,
    Func<String, T> elemAsText, {
    required int colPerRow,
    required int charPerElem,
    required Sep colSep,
    required Sep rowSep,
  })  : _data = data,
        _elemAsText = elemAsText,
        _colPerRow = colPerRow,
        _charPerElem = charPerElem,
        _colSep = colSep,
        _rowSep = rowSep;

  // the original data to be converted.
  final List<T> _data;
  // Converts each data element into a text representation.
  final Func<String, T> _elemAsText;
  // the number of columns per line.
  final int _colPerRow;
  // the number of symbols per each data element (word).
  final int _charPerElem;
  // the row separator.
  final Sep _colSep;
  // the line separator.
  final Sep _rowSep;

  /// The column separator.
  String get colSep => _colSep();

  /// The row separator.
  String get rowSep => _rowSep();

  /// The text representation of the word located at [i].
  String textAt(int i) => _elemAsText(_data[i]);

  /// The specified number of columns per line.
  int get colPerRow => _colPerRow;

  /// the total number of data elements.
  int get elems => _data.length;

  /// The total number of rows.
  int get rows => (elems / _colPerRow).ceil();

  /// The number of character codes per row separator.
  int get codePerRowSep => _rowSep().length;

  /// The total amount of row separator codes.
  int get rowSepCodes {
    if (rows <= 1) return 0;

    // As the last row must not contain any trailing separators, [codePerRowSep]
    // is subtracted from the expression. In this way, in cases where the number
    // of rows is 1, the result of the expression will be 0, which is the
    // expected result, because, by definition, single-row tables have no row
    // separator at all.
    return (rows * codePerRowSep) - codePerRowSep;
  }

  /// The number of character codes per column separator.
  int get colSepPerRow => _colPerRow - 1;

  /// The amount of column separator character codes per 'whole row'; that is,
  /// lines on which the number of columns is equal to the specified columns per
  /// row.
  int get colSepFullRow => colSepPerRow * (elems ~/ _colPerRow);

  /// The amount of column separator character codes on a 'partial row'. A
  /// partial row is always the last one and only occurs when the reminder of
  /// 'the number of data elements / columns per line' is not zero. Thus, when
  /// the reminder of the preceding division is not zero, the last line should
  /// contain the 'leftover' (remaining) columns, which in turn is a number that
  /// is always lesser than the specified number of columns per line.
  ///
  /// An example of a tabular, matrix-like text with 'leftover' columns:
  /// 01 02 03
  /// 04 05 06
  /// 07 08
  /// The last line contains only two columns instead of three.
  int get colSepPartialRow {
    final remainder = elems % _colPerRow;
    return remainder <= 1 ? 0 : remainder - 1;
  }

  /// The amount of character codes per column separator.
  int get codePerColSep => _colSep.value.length;

  /// The total number of character codes for the column separators.
  int get colSepCodes => codePerColSep * (colSepFullRow + colSepPartialRow);

  /// The total number of character codes necessary to represent the
  /// tabular text.
  int get numOfCharCodes => (elems * _charPerElem) + rowSepCodes + colSepCodes;
}
