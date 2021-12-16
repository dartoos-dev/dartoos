// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dartoos/src/radix/hex_bytes.dart';

import '../utils/perf_gain.dart';

/// Dartoos hexadecimal text vs. Dart's built-in conversion.
///
/// To run the benchmark and see the results, you can:
///
/// 1. run it directly as a Dart script
///    ```shell
///      dart /example/radix/hex_bytes_benchmark.dart
///    ```
///
/// 2. compile to 'jit' and run it
///    ```shell
///      dart compile jit-snapshot example/radix/hex_of_bytes_benchmark.dart
///      dart /example/radix/hex_bytes_benchmark.jit
///    ```
/// 3. compile to 'exe' and run it
///    ```shell
///      dart compile exe example/radix/hex_of_bytes_benchmark.dart
///      ./example/radix/hex_bytes_benchmark.exe
///    ```
///
/// Usually, the items 2 and 3 perform better.
void main() {
  print('\tDartoos vs. Dart sdk');

  const len = 5000000;
  final bytes = Uint8List.fromList(List<int>.generate(len, (int i) => i % 256));
  print('\nConversion of $len bytes to hexadecimal text');

  print('Start...');
  final watch = Stopwatch()..start();
  final dartHexText = bytesAsHexText(bytes);
  final elapsedDart = watch.elapsedMicroseconds / 1000;
  watch.stop();
  watch.reset();
  print('Dart elapsed time...: $elapsedDart milliseconds');

  watch.start();
  final dartoosHexText = hexBytes(bytes);
  final elapsedDartoos = watch.elapsedMicroseconds / 1000;
  watch.stop();
  watch.reset();
  print('Dartoos elapsed time: $elapsedDartoos milliseconds');

  final perf = const PerfGain().value(elapsedDart, elapsedDartoos);
  print('Performance ratio...: $perf (Dart elapsed time / Dartoos time)');
  final sameText = dartHexText == dartoosHexText;
  print('Are the generated hex texts the same? $sameText');
}

/// Typical Dart implementation.
String bytesAsHexText(Uint8List bytes) {
  final buffer = StringBuffer();
  for (var i = 0; i < bytes.length; ++i) {
    buffer.write(bytes[i].toRadixString(16).padLeft(2, '0'));
    // Even without padding, Dartoos is faster.
    // buffer.write(bytes[i].toRadixString(16));
  }
  return buffer.toString();
}
