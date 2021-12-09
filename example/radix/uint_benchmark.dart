// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dartoos/src/radix/uint.dart';

import '../utils/perf_gain.dart';

/// Dartoos unsigned integer text vs. Dart's built-in conversion.
///
/// To run the benchmark and see the results, you can:
///
/// 1. run it directly as a Dart script
///    ```shell
///      dart /example/radix/uint_benchmark.dart
///    ```
///
/// 2. compile to 'jit' and run it
///    ```shell
///      dart compile jit-snapshot example/radix/uint_benchmark.dart
///      dart /example/radix/uint_benchmark.jit
///    ```
/// 3. compile to 'exe' and run it
///    ```shell
///      dart compile exe example/radix/uint_benchmark.dart
///      dart /example/radix/uint_benchmark.exe
///    ```
///
/// Usually, the items 2 and 3 perform better.
void main() {
  print('\tDartoos vs. Dart sdk');
  const len = 5000000;
  // byte values varies from 0 up to 255.
  final bytes = Uint8List.fromList(List<int>.generate(len, (int i) => i % 256));
  print('\nConversion of ${bytes.lengthInBytes} bytes to decimal text');

  print('Start...');
  final watch = Stopwatch()..start();
  final dartUintText = bytes.map(toUintText).join();
  final elapsedDartTime = watch.elapsedMilliseconds;
  print('\nDart elapsed time...: $elapsedDartTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dartoosUintText = bytes.map<String>(uint8).join();
  final elapsedDartoosTime = watch.elapsedMilliseconds;
  print('Dartoos elapsed time: $elapsedDartoosTime milliseconds');
  watch.stop();

  final perf = const PerfGain().value(elapsedDartTime, elapsedDartoosTime);
  print(
    'Performance ratio...: $perf (Dart elapsed time / Dartoos elapsed time)',
  );
  print(
    "Are the generated decimal texts the same? ${dartUintText == dartoosUintText}",
  );
}

/// Convert an integer to its decimal text representation.
String toUintText(int word) {
  return word.toRadixString(10).padLeft(3, '0');
}
