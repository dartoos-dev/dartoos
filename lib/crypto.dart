/// Collection of cryptographic hash classes.
///
/// > Three of the main purposes of a hash function are:
/// > - to scramble data deterministically
/// > - to accept an input of arbitrary length and output a fixed length result
/// > - to manipulate data irreversibly. The input cannot be derived from the output
/// > — [qvault.io](https://qvault.io/cryptography/how-sha-2-works-step-by-step-sha-256/)
library crypto;

export 'src/crypto/hash/hash.dart';
export 'src/crypto/hash/hex_hash.dart';
export 'src/crypto/hash/hex_hmac.dart';
export 'src/crypto/hash/hmac.dart';
export 'src/crypto/hash/sha256.dart';
export 'src/crypto/hash/sha512.dart';
