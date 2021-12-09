// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dartoos/src/radix/bin.dart';

import '../utils/perf_gain.dart';

/// Dartoos binary text vs. Dart's built-in conversion.
///
/// To run the benchmark and see the results, you can:
///
/// 1. run it directly as a Dart script
///    ```shell
///      dart /example/radix/bin_benchmark.dart
///    ```
///
/// 2. compile to 'jit' and run it
///    ```shell
///      dart compile jit-snapshot example/radix/bin_benchmark.dart
///      dart /example/radix/bin_benchmark.jit
///    ```
/// 3. compile to 'exe' and run it
///    ```shell
///      dart compile exe example/radix/bin_benchmark.dart
///      ./example/radix/bin_benchmark.exe
///    ```
///
/// Usually, the items 2 and 3 perform better.
void main() {
  print('\tDartoos vs. Dart sdk');
  const len = 2500000;
  // byte values varies from 0 up to 255.
  final bytes = Uint8List.fromList(List<int>.generate(len, (int i) => i % 256));
  print('\nConversion of $len bytes to binary text');

  print('Start...');
  final watch = Stopwatch()..start();
  final dartBinText = bytes.map(toBinText).join();
  final elapsedDartTime = watch.elapsedMicroseconds / 1000;
  print('\nDart elapsed time...: $elapsedDartTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dartoosBinText = bytes.map<String>(bin).join();
  final elapsedDartoosTime = watch.elapsedMicroseconds / 1000;
  print('Dartoos elapsed time: $elapsedDartoosTime milliseconds');
  watch.stop();

  final perf = const PerfGain().value(elapsedDartTime, elapsedDartoosTime);
  print(
    'Performance.........: $perf (Dart elapsed time / Dartoos elapsed time)',
  );
  print("Are the generated texts the same? ${dartBinText == dartoosBinText}");
}

/// Convert an integer to its binary text representation.
String toBinText(int word) {
  return word.toRadixString(2).padLeft(64, '0');
}
