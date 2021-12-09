import '../text/sep.dart';
import '../text/tab_text_of_data.dart';
import 'bin.dart';
import 'radix.dart';

/// Data representation in tabular text with digits in binary notation.
///
/// It is a convenience wrapper over [TabTextOfData].
///
/// Examples:
///
/// Given the values 0, 1, 2, 3, 4, 5, 6, 7:
///
/// - a two-column table/matrix
/// 00000000 00000001 000000010 00000011
/// 00000100 00000101 000000110 00000111
///
/// - a three-column table
/// 00000000 00000001 00000010
/// 00000011 00000100 00000101
/// 00000110 00000111
///
/// - a single-column table
/// 00000000
/// 00000001
/// …
/// 00000110
/// 00000111
///
/// - a single-row table
/// 00000000 00000001 000000010 00000011 00000100 00000101 000000110 00000111
class BinTab implements DataAsTabText {
  /// Tabular text of _n-bit word_ data in binary text.
  ///
  /// When transforming elements into table cells, [elemAsText] is used to
  /// convert each element into its binary text of [charPerElem] characters.
  /// representation. The table cells (columns) are then separated from each
  /// other with the column separator character [colSep], and the rows are
  /// separated from each other with the row separator [rowSep]. Each row will
  /// contain [colPerRow] cells, unless it is the last row and the number of
  /// elements is not divisible by [colPerRow]; if this is the case, the number
  /// of cells in the last row will be the remainder of the division of the
  /// number of elements by [colPerRow]. For example, if there are ten elements
  /// and 'colPerRow' is equal to 4, the number of cells in the last row will be
  /// 2, since 10 mod 4 = 2.
  ///
  /// [elemAsText] converts a element into binary text.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  ///
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  ///
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  BinTab(
    Bin elemAsText, {
    required int charPerElem,
    required int colPerRow,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : _binTabText = TabTextOfData(
          charPerElem: charPerElem,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
          elemAsText: elemAsText,
        );

  /// Tabular text of _8-bit word_ data in binary text.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  BinTab.w8({
    int colPerRow = 8,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          bin8,
          charPerElem: 8,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text of _16-bit word_ data in binary text.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  BinTab.w16({
    int colPerRow = 8,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          bin16,
          charPerElem: 16,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text representation of _32-bit word_ data in binary text.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  BinTab.w32({
    int colPerRow = 8,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          bin32,
          charPerElem: 32,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text representation of _64-bit word data_ in binary text.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  BinTab.w64({
    int colPerRow = 8,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          bin64,
          charPerElem: 64,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  final TabTextOfData _binTabText;

  @override
  String call(List<int> data) => _binTabText(data);
}
