import 'package:dartoos/func.dart';

/// A text
abstract class Text implements Scalar<String> {
  /// This object as [String]; forwards to [call].
  @override
  String toString() => this();
}

/// Convenience class for transforming an input of type T into a [String]
/// representation by invoking its [toString] method.
class ToStringOf<T> implements Func<String, T> {
  /// Will call [toString] when transforming inputs into text.
  const ToStringOf();

  /// Returns the text representation of [input] by invoking its [toString]
  /// method.
  @override
  String call(T input) => input.toString();
}

/// Something that converts [t] to text.
// typedef AsText<T> = String Function(T t);

/// Something that retrieves text.
typedef ToText<T> = String Function();

/// List of elements as text.
abstract class ListAsText<T> implements Func<String, List<T>> {}
