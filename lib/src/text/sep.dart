import 'text.dart';

/// Sep — Characters Separator
///
/// It represents characters commonly used as text separators.
class Sep with Text {
  /// Encapsulates a [String] to be used as a text separator.
  const Sep(this.value);

  /// No separator _''_.
  const Sep.none() : this('');

  /// Space _' '_ — ASCII code 0x20.
  const Sep.sp() : this(' ');

  /// Line Feed _'\n'_ — ASCII code 0x0A.
  const Sep.lf() : this('\n');

  /// New Line — forwards to [Sep.lf].
  const Sep.nl() : this.lf();

  /// Carriage Return _'\r'_ — ASCII code 0x0D.
  const Sep.cr() : this('\r');

  /// Carriage Return and Line Feed _'\r\n'_ — ASCII code 0x0D0A.
  const Sep.crlf() : this('\r\n');

  /// Horizontal Tab _'\t'_ — ASCII code 0x09.
  const Sep.tab() : this('\t');

  /// Vertical Tab _'\v'_ — ASCII code 0x0B.
  const Sep.vt() : this('\v');

  /// Form Feed _'\f'_ — ASCII code 0x0C.
  const Sep.ff() : this('\f');

  /// New Page — forwards to [Sep.ff].
  const Sep.np() : this.ff();

  /// Whitespace characters.
  ///
  /// It is the concatenation of:
  /// - Space ' '
  /// - Carriage Return '\r'
  /// - Line Feed (New Line) '\n'
  /// - Horizontal Tab '\t'
  /// - Vertical Tab '\v'
  /// - Formfeed '\f'
  ///
  /// Aggregated ASCII code: 0x200D0A090B0C
  const Sep.ws() : this(' \r\n\t\v\f');

  /// The text separator(s).
  final String value;

  /// The text separator(s).
  @override
  String call() => value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) => value == other;
}
