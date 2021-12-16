import 'dart:typed_data';

import 'package:dartoos/crypto.dart';
import 'package:dartoos/radix.dart';

/// Hex string of the [sha224] hash function.
const HashStr hexSha224 = _HexHash.sha224();

/// Hex string of the [sha256] hash function.
const HashStr hexSha256 = _HexHash.sha256();

/// Hex string of the [sha384] hash function.
const HashStr hexSha384 = _HexHash.sha384();

/// Hex string of the [sha512] hash function.
const HashStr hexSha512 = _HexHash.sha512();

/// A hash value (digest) as hex string.
class _HexHash implements HashStr {
  /// Sets the hash function.
  const _HexHash(this._digest);

  /// SHA-224 as the hash function.
  const _HexHash.sha224() : this(sha224);

  /// SHA-256 as the hash function.
  const _HexHash.sha256() : this(sha256);

  /// SHA-384 as the hash function.
  const _HexHash.sha384() : this(sha384);

  /// SHA-512 as the hash function.
  const _HexHash.sha512() : this(sha512);

  final HashByte _digest;

  // static const _hexBytes = HexOfBytes();

  /// Convenience method; forwards to [call].
  String value(Uint8List input) => this(input);

  /// The message digest of [input] as a string of hexadecimal digits.
  @override
  String call(Uint8List input) => hexBytes(_digest(input));
}
