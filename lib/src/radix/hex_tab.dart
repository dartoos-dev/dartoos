import '../text/sep.dart';
import '../text/tab_text_of_data.dart';
import 'hex.dart';
import 'radix.dart';

/// Data representation in tabular text with digits in hexadecimal notation.
///
/// It is a convenience wrapper over [TabTextOfData].
class HexTab implements DataAsTabText {
  /// Tabular text of _n-bit word_ data in hexadecimal.
  ///
  /// When transforming elements into table cells, [elemAsText] is used to
  /// convert each element into its hexadecimal text of [charPerElem]
  /// characters. The table cells (columns) are then separated from each other
  /// with the column separator character [colSep], and the rows are separated
  /// from each other with the row separator [rowSep]. Each row will contain
  /// [colPerRow] cells, unless it is the last row and the number of elements is
  /// not divisible by [colPerRow]; if this is the case, the number of cells in
  /// the last row will be the remainder of the division of the number of
  /// elements by [colPerRow]. For example, if there are ten elements and
  /// 'colPerRow' is equal to 4, the number of cells in the last row will be 2,
  /// since 10 mod 4 = 2.
  ///
  /// [elemAsText] converts a element into hexadecimal text.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  ///
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  ///
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  HexTab(
    Hex elemAsText, {
    required int charPerElem,
    required int colPerRow,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : _hexTabText = TabTextOfData(
          charPerElem: charPerElem,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
          elemAsText: elemAsText,
        );

  /// Tabular text of _8-bit word_ data in hexadecimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  HexTab.w8({
    int colPerRow = 16,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          hex8,
          charPerElem: 2,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text of _16-bit word_ data in hexadecimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  HexTab.w16({
    int colPerRow = 8,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          hex16,
          charPerElem: 4,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text representation of _32-bit word_ data in hexadecimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  HexTab.w32({
    int colPerRow = 4,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          hex32,
          charPerElem: 8,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text representation of _64-bit word data_ in hexadecimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  HexTab.w64({
    int colPerRow = 2,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          hex64,
          charPerElem: 16,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  // The actual implementation.
  final TabTextOfData _hexTabText;

  @override
  String call(List<int> data) => _hexTabText(data);
}
