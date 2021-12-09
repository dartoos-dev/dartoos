/// Interfaces of the bit library

import '../func.dart';

/// A group of related bits to serve as an operand of bitwise operations
abstract class Bits implements Scalar<int> {}

/// Binary (two-operands) bitwise operation.
abstract class BitwiseBi implements BiFunc<int, int, int> {
  /// The result of [left] operation [right].
  @override
  int call(int left, int right);
}

/// Unary bitwise operations
abstract class BitwiseUn implements Func<int, int> {
  /// The result of a bitwise operation on [operand].
  @override
  int call(int operand);
}

/// The number of bits required to represent the values of n-bit _words_.
abstract class BitLen implements Func<int, int> {
  /// The minimum amount of bits to represent the value of [word].
  ///
  /// Typically, this value is in the range [1–64].
  @override
  int call(int word);
}
