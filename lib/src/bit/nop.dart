import 'bit.dart';

/// NOP — No operation
///
/// It serves as a placeholder operand.
class Nop implements BitwiseUn {
  /// Performs no operation.
  const Nop();

  /// Performs no operation — returns [operand] as-is.
  @override
  int call(int operand) => operand;
}
