// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:dartoos/src/radix/oct.dart';

import '../utils/perf_gain.dart';

/// Dartoos octal text vs. Dart's built-in conversion.
///
/// To run the benchmark and see the results, you can:
///
/// 1. run it directly as a Dart script
///    ```shell
///      dart /example/radix/oct_benchmark.dart
///    ```
///
/// 2. compile to 'jit' and run it
///    ```shell
///      dart compile jit-snapshot example/radix/oct_of_benchmark.dart
///      dart /example/radix/oct_benchmark.jit
///    ```
/// 3. compile to 'exe' and run it
///    ```shell
///      dart compile exe example/radix/oct_of_benchmark.dart
///      ./example/radix/oct_benchmark.exe
///    ```
///
/// Usually, the items 2 and 3 perform better.
void main() {
  print('\tDartoos vs. Dart sdk');
  const len = 5000000;
  // byte values varies from 0 up to 255.
  final bytes = Uint8List.fromList(List<int>.generate(len, (int i) => i % 256));
  print('\nConversion of $len bytes to octal text');

  print('Start...');
  final watch = Stopwatch()..start();
  final dartOctText = bytes.map(toOctalText).join();
  final elapsedDartTime = watch.elapsedMicroseconds / 1000;
  print('\nDart elapsed time...: $elapsedDartTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dartoosOctText = bytes.map<String>(oct8).join();
  final elapsedDartoosTime = watch.elapsedMicroseconds / 1000;
  print('Dartoos elapsed time: $elapsedDartoosTime milliseconds');
  watch.stop();

  final perf = const PerfGain().value(elapsedDartTime, elapsedDartoosTime);
  print(
    'Performance ratio...: $perf (Dart elapsed time / Dartoos elapsed time)',
  );
  print(
    "Are the generated octal texts the same? ${dartOctText == dartoosOctText}",
  );
}

/// Convert an integer to its octary text representation.
String toOctalText(int word) {
  return word.toRadixString(8).padLeft(3, '0');
}
