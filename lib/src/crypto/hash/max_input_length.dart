import 'dart:typed_data';

import 'package:dartoos/func.dart';

/// Checks whether the length of the original input message is supported.
///
/// Currently, the larger length is limited to 2^53 because JavaScript uses
/// double-precision floating-point numbers and can only (safely) represent
/// integers between -(2^53 - 1) and 2^53.
const isLengthSupported = _MaxInputLength.js();

/// Messages whose length is larger than 2^53-1 bits are not supported
class _MaxInputLength implements Func<bool, Uint8List> {
  /// Sets the maximum value.
  const _MaxInputLength._(this._max);

  /// JavaScript uses double-precision floating-point format numbers as
  /// specified in IEEE 754 and can only safely represent integers between
  /// -(2^53 - 1) and 2^53 - 1.
  const _MaxInputLength.js() : this._(0x3ffffffffffff);

  final int _max;

  /// Checks whether the length in bytes of [input] is supported.
  @override
  bool call(Uint8List input) => input.lengthInBytes <= _max;
}
