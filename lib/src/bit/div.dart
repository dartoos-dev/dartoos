import 'bit.dart';

/// Truncating Division
class Div implements BitwiseBi {
  /// `dividend ~/ divisor`.
  const Div();

  /// The quotient of dividing [dividend] by [divisor].
  @override
  int call(int divident, int divisor) => divident ~/ divisor;
}
