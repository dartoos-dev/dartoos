import 'dart:typed_data';

import 'package:dartoos/crypto.dart';
import 'package:dartoos/radix.dart';

/// An Hmac value as hex string.
class HexHmac implements HashStr {
  /// Sets the hash function.
  const HexHmac(this._digest);

  /// SHA-224 as the hash function.
  HexHmac.sha224(Uint8List key) : this(Hmac.sha224(key));

  /// SHA-256 as the hash function.
  HexHmac.sha256(Uint8List key) : this(Hmac.sha256(key));

  /// SHA-384 as the hash function.
  HexHmac.sha384(Uint8List key) : this(Hmac.sha384(key));

  /// SHA-512 as the hash function.
  HexHmac.sha512(Uint8List key) : this(Hmac.sha512(key));

  final HashByte _digest;

  /// Convenience method; forwards to [call].
  String value(Uint8List input) => this(input);

  /// The message digest of [input] as a string of hexadecimal digits.
  @override
  String call(Uint8List input) => hexBytes(_digest(input));
}
