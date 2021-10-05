import 'future_wrap.dart';

/// Represents a Future<String> value.
abstract class Text extends FutureWrap<String> {
  /// Constructs a Text from a Future<String>
  Text(Future<String> text) : super(text);

  /// Text from value.
  Text.value(String value) : super.value(value);
}
