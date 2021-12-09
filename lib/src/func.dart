/// Library of functional interfaces.
library func;

/// A runnable (executable) object.
abstract class Run {
  /// Run it.
  void call();
}

/// A scalar value of type [R].
///
/// Examples:
///
/// ```dart
///   /// A unit of measure.
///   abstract class Measure<N extends num> implements Scalar<N> {
///
///     /// The size, amount or degree of something.
///     @override
///     N call();
///   }
///   /// A logical (resolution-independent) value.
///
///   /// Pixel is the unit of measure for the dimensions of a graphical component,
///   /// such as the padding, width, or height thereof.
///   abstract class Pixel implements Measure<double> {
///     /// The amount of pixels.
///     @override
///     double call();
///
///     /// Convenience getter; forwards to [call].
///     double get value => call();
///   }
/// ```
abstract class Scalar<R> {
  /// The value.
  R call();
}

/// A function that accepts one input argument of type [I] and returns [R].
abstract class Func<R, I> {
  /// Apply [input] to produce a result [R].
  R call(I input);
}

/// A function that accepts two input arguments and returns [R].
abstract class BiFunc<R, I1, I2> {
  /// Apply [left] and [right] to produce a result [R].
  R call(I1 left, I2 right);
}

/// A unary procedure — it accepts one input argument.
abstract class Proc<I> implements Func<void, I> {
  /// Execute it.
  @override
  void call(I input);
}

/// A binary procedure — it accepts two input arguments.
abstract class BiProc<I1, I2> implements BiFunc<void, I1, I2> {
  /// Execute it.
  @override
  void call(I1 first, I2 second);
}
