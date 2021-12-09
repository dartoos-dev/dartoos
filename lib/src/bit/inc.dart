import 'bit.dart';

/// Increment Operation.
class Inc implements BitwiseUn {
  /// Increments by a fixed [n]-value on each call to [value].
  const Inc([int n = 1]) : _n = n;

  final int _n;

  /// The incremented value of [word].
  @override
  int call(int word) => word + _n;
}
