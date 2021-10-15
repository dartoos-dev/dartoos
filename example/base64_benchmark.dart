// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartoos/dartoos.dart';

/// Dartoos base64-encoder/decoder vs. Dart's built-in base64-encoder/decoder.
///
/// Running:
/// ```dart /example/base64_benchmark.dart```
///
/// or
/// 
/// Compile to 'jit'.
/// ```dart compile jit-snapshot example/base64_benchmark.dart```
/// ```dart /example/base64_benchmark.jit```
Future<void> main() async {
  print("Dartoos base64 vs. Dart's built-in base64...");

  const wordLength = 15000000; const elegibleChars =
      r'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-*/|\;:?[]{}()!@#$%*';
  // The bytes of a randomly generated word whose length is [wordLength]
  // characters.
  final bytes = await BytesOf.utf8(Rand(wordLength, elegibleChars));

  final dartEncodingStart = DateTime.now().millisecondsSinceEpoch;
  final dartEncoded = base64Encode(bytes);
  final dartEncodingTime =
      DateTime.now().millisecondsSinceEpoch - dartEncodingStart;

  final dartDecodingStart = DateTime.now().millisecondsSinceEpoch;
  final dartDecoded = base64Decode(dartEncoded);
  final dartDecodingTime =
      DateTime.now().millisecondsSinceEpoch - dartDecodingStart;

  final dartoosEncodingStart = DateTime.now().millisecondsSinceEpoch;
  final dartoosEncoded = await Base64(bytes);
  final dartoosEncodingTime =
      DateTime.now().millisecondsSinceEpoch - dartoosEncodingStart;

  final dartoosDecodingStart = DateTime.now().millisecondsSinceEpoch;
  final dartoosDecoded = await Base64Decode(dartoosEncoded);
  final dartoosDecodingTime =
      DateTime.now().millisecondsSinceEpoch - dartoosDecodingStart;

  print('\n--- Encoding elapsed times ---'); 
  print('Dartoos base64-encoding: $dartoosEncodingTime ms');
  print('Builtin base64-encoding: $dartEncodingTime ms');
  print('\n--- Decoding elapsed times ---'); 
  print('Dartoos base64-decoding: $dartoosDecodingTime ms');
  print('Builtin base64-decoding: $dartDecodingTime ms');
  print('\n--- Encoding/decoding results comparison ---');
  print('dartoosEncoded == dartEncoded? ${dartoosEncoded == dartEncoded}');
  print(
    'dartoosDecoded == dartDecoded? ${decodedEqual(dartoosDecoded, dartDecoded)}',
  );
  print('\nEncoded text length: $wordLength characters.');
}

bool decodedEqual(Uint8List first, Uint8List second) {
  if (first.length != second.length) return false;
  final length = first.length;
  int i = 0;
  while (i < length && first[i] == second[i]) {
    ++i;
  }
  return i == length;
}
