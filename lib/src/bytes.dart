import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'future_wrap.dart';

/// Represents a source of raw bytes.
abstract class Bytes extends FutureWrap<Uint8List> {
  /// Encapsulates a Future of bytes.
  Bytes(FutureOr<Uint8List> bytes) : super(bytes);
}

/// An amount of bytes from several sources.
class BytesOf extends Bytes {
  /// Raw bytes from [bytes].
  BytesOf(FutureOr<Uint8List> bytes) : super(bytes);

  /// List of integers as [Uint8List].
  BytesOf.list(FutureOr<List<int>> list)
      : this(Future(() async => Uint8List.fromList(await list)));

  /// String as a list of UTF-8 bytes.
  BytesOf.utf8(FutureOr<String> str)
      : this.list(Future(() async => utf8.encode(await str)));

  /// The file's content as bytes.
  BytesOf.file(FutureOr<File> file)
      : this(Future(() async => (await file).readAsBytes()));
}
