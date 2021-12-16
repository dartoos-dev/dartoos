import 'package:dartoos/func.dart';
import 'package:dartoos/text.dart';

/// Callback to be invoked whenever a new row is about to be generated.
///
/// **Note**: the [row] numbers start at _1_ instead of _0_ (zero).
typedef OnNewRow = String Function(int row, int colPerRow);

/// The optional header for tabular text [TabText]
///
/// The [Sep] instance is what separates the header content from the body of the
/// tabular text
class Header with Text {
  /// Header with the new line character '\n' as the separator.
  const Header(String content) : this.custom(content, const Sep.nl());

  /// No header.
  const Header.empty() : this.custom('', const Sep.none());

  /// Sets the content and separator.
  const Header.custom(this._content, this._sep);

  final String _content;
  final Sep _sep;

  /// Returns the concatenation between the defined content and separator.
  /// ```dart
  ///  return '$_content$_sep';
  /// ```
  @override
  String call() => '$_content$_sep';
}

/// The optional footer for tabular text [TabText]
///
/// The [Sep] instance is what separates the header content from the body of the
/// tabular text
class Footer with Text {
  /// Footer with the new line character '\n' as the separator.
  const Footer(String content) : this.custom(content, const Sep.nl());

  /// No footer.
  const Footer.empty() : this.custom('', const Sep.none());

  /// Sets the content and separator.
  const Footer.custom(this._content, this._sep);

  final String _content;
  final Sep _sep;

  /// Returns the concatenation between the defined separator and content.
  ///
  /// ```dart
  ///  return '$_sep$_content';
  /// ```
  @override
  String call() => '$_sep$_content';
}

/// Text in tabular (table or matrix-like) format.
class TabText<T> implements ListAsText<T> {
  /// Text in tabular (table) matrix format.
  ///
  /// [colPerRow] the number of columns per row.
  /// [colSep] the column separator; if omitted, a single space ' ' will be used
  /// as the column separator.
  /// [rowSep] the row separator; if omitted, a new line character '\n' will be
  /// used as the row separator.
  /// [header] an optional row to be placed above all other rows.
  /// [footer] an optional row to be placed below all other rows.
  /// [elemAsText] converts each element of the list into its text
  /// representation; if omitted, the default behavior is to invoke the
  /// [toString] method of each element.
  /// [onNewRow] callback invoked whenever a new row is about to be generated.
  /// It is the opportunity for the client code to make the header cell of the
  /// next line.
  const TabText({
    required int colPerRow,
    Sep colSep = const Sep.sp(),
    Sep rowSep = const Sep.nl(),
    Header header = const Header.empty(),
    Footer footer = const Footer.empty(),
    Func<String, T> elemAsText = const ToStringOf(),
    OnNewRow? onNewRow,
  })  : assert(colPerRow > 0),
        _colSep = colSep,
        _rowSep = rowSep,
        _header = header,
        _footer = footer,
        _colPerRow = colPerRow,
        _elemAsText = elemAsText,
        _onNewRow = onNewRow;

  final int _colPerRow;
  final Sep _colSep;
  final Sep _rowSep;
  final Header _header;
  final Footer _footer;
  final Func<String, T> _elemAsText;
  final OnNewRow? _onNewRow;

  /// Returns the tabular text representation of [elems].
  @override
  String call(List<T> elems) {
    final buffer = StringBuffer(_header);
    if (_onNewRow != null) {
      _withRowHeader(buffer, elems);
    } else {
      _noRowHeader(buffer, elems);
    }
    buffer.write(_footer);

    return buffer.toString();
  }

  /// Table with no row headers.
  void _noRowHeader(StringBuffer buff, List<T> elems) {
    var colPosInRow = 1; // the column position in the current row.
    final last = elems.length - 1;
    for (var i = 0; i < last; ++i) {
      colPosInRow = _cell(buff, elems[i], colPosInRow);
    }
    _lastCell(buff, elems.last);
  }

  /// Table with row headers.
  void _withRowHeader(StringBuffer buff, List<T> elems) {
    var columns = 1; // the total of columns
    var colPosInRow = 1; // the column position in the current row.
    final last = elems.length - 1;
    for (var i = 0; i < last; ++i) {
      if (colPosInRow == 1) {
        _rowHeader(buff, columns);
      }
      colPosInRow = _cell(buff, elems[i], colPosInRow);
      ++columns;
    }
    _lastCell(buff, elems.last);
  }

  /// Makes the last cell of the table without separator characters.
  void _lastCell(StringBuffer buff, T elem) {
    buff.write(_elemAsText(elem));
  }

  /// Makes a new table row.
  void _rowHeader(StringBuffer buffer, int columns) {
    final row = 1 + (columns ~/ _colPerRow);
    buffer.write(_onNewRow!(row, _colPerRow));
    buffer.write(_colSep);
  }

  /// Makes a cell with [elem] at [posInRow] and returns the next cell position.
  int _cell(StringBuffer buff, T elem, int posInRow) {
    buff.write(_elemAsText(elem));
    int nextPosInRow = 1;
    if (posInRow < _colPerRow) {
      buff.write(_colSep); // new column
      nextPosInRow += posInRow;
    } else {
      buff.write(_rowSep); // new row
    }
    return nextPosInRow;
  }
}
