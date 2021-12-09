import '../text/sep.dart';
import '../text/tab_text_of_data.dart';
import 'radix.dart';
import 'uint.dart';

/// Data representation in tabular text with decimal digits.
///
/// It is a convenience wrapper over [TabTextOfData].
class UintTab implements DataAsTabText {
  /// Tabular text of _n-bit word_ data in decimal.
  ///
  /// When transforming elements into table cells, [elemAsText] is used to
  /// convert each element into its decimal text of [charPerElem] characters.
  /// The table cells (columns) are then separated from each other with the
  /// column separator character [colSep], and the rows are separated from each
  /// other with the row separator [rowSep]. Each row will contain [colPerRow]
  /// cells, unless it is the last row and the number of elements is not
  /// divisible by [colPerRow]; if this is the case, the number of cells in the
  /// last row will be the remainder of the division of the number of elements
  /// by [colPerRow]. For example, if there are ten elements and 'colPerRow' is
  /// equal to 4, the number of cells in the last row will be 2, since 10 mod 4
  /// = 2.
  ///
  /// [elemAsText] converts a element into decimal text.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  ///
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  ///
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  UintTab(
    Uint elemAsText, {
    required int charPerElem,
    required int colPerRow,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : _uintTabText = TabTextOfData(
          charPerElem: charPerElem,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
          elemAsText: elemAsText,
        );

  /// Tabular text of _8-bit word_ data in decimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  UintTab.w8({
    int colPerRow = 10,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          uint8,
          charPerElem: 3,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text of _16-bit word_ data in decimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  UintTab.w16({
    int colPerRow = 10,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          uint16,
          charPerElem: 5,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text representation of _32-bit word_ data in decimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  UintTab.w32({
    int colPerRow = 10,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          uint32,
          charPerElem: 10,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  /// Tabular text representation of _64-bit word data_ in decimal.
  ///
  /// [colPerRow] the number of columns (cells) per row; it defaults to 8.
  /// [colSep] the column separator character; if omitted, a single space _' '_
  /// will be used to separate adjacent columns.
  /// [rowSep] the row separator character; if omitted, the linefeed _'\n'_ will
  /// be used to separate adjacent rows.
  UintTab.w64({
    int colPerRow = 10,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
  }) : this(
          uint64,
          charPerElem: 19,
          colPerRow: colPerRow,
          colSep: colSep,
          rowSep: rowSep,
        );

  // The actual implementation.
  final TabTextOfData _uintTabText;

  @override
  String call(List<int> data) => _uintTabText(data);
}
