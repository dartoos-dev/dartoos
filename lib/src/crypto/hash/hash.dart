import 'dart:typed_data';

import 'package:dartoos/func.dart';

/// Represents a cryptographic hash function.
abstract class Hash<R extends List<int>, I extends List<int>>
    implements Func<R, I> {}

/// Hash function that maps data of an arbitrary size (the "message") to a
/// byte list of fixed size.
abstract class HashByte implements Hash<Uint8List, Uint8List> {
  /// The size in bytes of the 'message chuncks'.
  ///
  /// A hash function breaks up a message into blocks of a fixed size and
  /// iterates over them with a compression function.
  int get blockSizeInBytes;
}

/// For hash functions that break messages in 64-byte chuncks (blocks).
abstract class ChunksOf64Bytes implements HashByte {
  /// 64 bytes or 512 bits.
  @override
  int get blockSizeInBytes => 64;
}

/// For hash functions that break messages in 128-byte chuncks (blocks).
abstract class ChunksOf128Bytes implements HashByte {
  /// 128 bytes or 1024 bits.
  @override
  int get blockSizeInBytes => 128;
}

/// Converts the hash value ("digest") to [String].
abstract class HashStr implements Func<String, Uint8List> {}
