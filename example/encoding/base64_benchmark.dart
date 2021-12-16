// ignore_for_file: avoid_print
import 'dart:convert';
import 'dart:typed_data';

import 'package:dartoos/dartoos.dart' as dartoos;

import '../utils/perf_gain.dart';

/// Dartoos base64-encoder/decoder vs. Dart's built-in base64-encoder/decoder.
///
/// Running:
/// ```shell
///   dart run example/encoding/base64_benchmark.dart
/// ```
///
/// or
///
/// Compile to 'jit'.
/// ```shell
///   dart compile jit-snapshot example/encoding/base64_benchmark.dart
///   dart run /example/encoding/base64_benchmark.jit
/// ```
void main() {
  print("Dartoos base64 vs. Dart's built-in base64...");

  const len = 50000000;
  const alphabet =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final bytes = dartoos.BytesOf.text(dartoos.RandOf(alphabet, len)).value;
  print('\nLength of the data to be encoded: ${bytes.length} bytes.');

  print('\n--- Encoding elapsed times ---');
  final watch = Stopwatch()..start();
  final dartEnc = base64Encode(bytes);
  final dartEncTime = watch.elapsedMicroseconds / 1000;
  print('Dart base64-encoding......: $dartEncTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dartoosEnc = dartoos.base64(bytes);
  final dartoosEncTime = watch.elapsedMicroseconds / 1000;
  print('Dartoos base64-encoding...: $dartoosEncTime milliseconds');
  watch.stop();
  watch.reset();
  const perf = PerfGain();
  print('Encoding Performance......: ${perf(dartEncTime, dartoosEncTime)}');

  print('\n--- Decoding elapsed times ---');
  watch.start();
  final dartDec = base64Decode(dartEnc);
  final dartDecTime = watch.elapsedMicroseconds / 1000;
  print('Dart base64-decoding......: $dartDecTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dartoosDec = dartoos.base64Dec(dartoosEnc);
  final dartoosDecTime = watch.elapsedMicroseconds / 1000;
  print('Dartoos base64-decoding...: $dartoosDecTime milliseconds');
  watch.stop();
  watch.reset();
  print('Decoding Performance......: ${perf(dartDecTime, dartoosDecTime)}');

  print('\n--- Encoding/decoding results comparison ---');
  print('dartEncoded == dartoosEncoded? ${dartEnc == dartoosEnc}');
  print('dartDecoded == dartoosDecoded? ${bytesEqual(dartDec, dartoosDec)}');
}

/// Checks for the equality between [first] and [second].
bool bytesEqual(Uint8List first, Uint8List second) {
  if (first.length != second.length) return false;
  final length = first.length;
  int i = 0;
  while ((i < length) && (first[i] == second[i])) {
    ++i;
  }
  return i == length;
}
