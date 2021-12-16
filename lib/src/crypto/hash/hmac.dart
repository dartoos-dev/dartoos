import 'dart:typed_data';

import 'package:dartoos/crypto.dart';

/// Hash-based Message Authentication Code
///
/// For further information, see:
///
/// - [RFC 2104](https://datatracker.ietf.org/doc/html/rfc2104)
class Hmac implements HashByte {
  /// HMAC-X, where X is the hash function.
  Hmac(HashByte hash, Uint8List secret)
      : _hash = hash,
        _key = Uint8List(hash.blockSizeInBytes),
        _innerKeyPad = Uint8List(hash.blockSizeInBytes),
        _outerKeyPad = Uint8List(hash.blockSizeInBytes) {
    _setKey(secret, blockSizeInBytes);
    _setPad(blockSizeInBytes);
  }

  /// HMAC-SHA224
  Hmac.sha224(Uint8List secret) : this(sha224, secret);

  /// HMAC-SHA256
  Hmac.sha256(Uint8List secret) : this(sha256, secret);

  /// HMAC-SHA384
  Hmac.sha384(Uint8List secret) : this(sha384, secret);

  /// HMAC-SHA512
  Hmac.sha512(Uint8List secret) : this(sha512, secret);

  // the cryptographic hash function.
  final HashByte _hash;
  // The secret key
  final Uint8List _key;

  final Uint8List _innerKeyPad;
  final Uint8List _outerKeyPad;

  /// Sets the key with proper padding.
  void _setKey(Uint8List secret, int size) {
    final key = secret.lengthInBytes > size ? _hash(secret) : secret;
    _key.setRange(0, key.length, key);
  }

  // Inner and outer key paddings.
  void _setPad(int size) {
    for (var i = 0; i < size; ++i) {
      final keyValue = _key[i];
      _innerKeyPad[i] = keyValue ^ 0x36;
      _outerKeyPad[i] = keyValue ^ 0x5c;
    }
  }

  /// Convenience method; forwards to [call].
  Uint8List value(Uint8List message) => this(message);

  /// Forwards to the encapsulated hash function.
  @override
  int get blockSizeInBytes => _hash.blockSizeInBytes;

  /// Returns the HMAC value of [message].
  @override
  Uint8List call(Uint8List message) => _hash(_outer(_hash(_inner(message))));

  /// The outer concatenation
  Uint8List _outer(Uint8List innerHash) {
    return (BytesBuilder(copy: false)
          ..add(_outerKeyPad)
          ..add(innerHash))
        .toBytes();
  }

  /// The inner concatenation.
  Uint8List _inner(Uint8List message) {
    return (BytesBuilder(copy: false)
          ..add(_innerKeyPad)
          ..add(message))
        .toBytes();
  }
}
