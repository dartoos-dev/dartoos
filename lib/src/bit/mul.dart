import 'bit.dart';

/// Multiplication Operation.
///
/// > _multiplicand_: a quantity which is to be multiplied by another.
/// > _multiplier: a value that multiplies.
class Mul implements BitwiseBi {
  /// `multiplicand * multiplier`
  const Mul();

  /// The product of multiplying [multiplicand] by [multiplier].
  @override
  int call(int multiplicand, int multiplier) => multiplicand * multiplier;
}
