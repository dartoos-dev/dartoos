import 'dart:async';

import 'future_wrap.dart';

/// Represents a source of text as [String].
abstract class Text extends FutureWrap<String> {
  /// Constructs a Text from a Future<String>
  Text(FutureOr<String> text) : super(text);
}
