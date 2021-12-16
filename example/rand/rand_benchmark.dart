// ignore_for_file: avoid_print

import 'dart:math';

import 'package:dartoos/rand.dart';

/// Dartoos random text generator vs. Dart's built-in generator.
///
/// To run the benchmark and see the results, you can:
///
/// 1. run it directly as a Dart script
///   ```shell
///      dart /example/rand/rand_benchmark.dart
///    ```
///
/// 2. compile to 'jit' and run it
///   ```shell
///      dart compile jit-snapshot example/rand/rand_benchmark.dart
///      dart /example/rand/rand_benchmark.jit
///   ```
/// 3. compile to 'exe' and run it
///    ```shell
///      dart compile exe example/rand/rand_benchmark.dart
///      ./example/rand/rand_benchmark.exe
///    ```
///
/// Usually, the items 2 and 3 perform better.
void main() {
  print('\tDartoos vs. Dart sdk');

  const len = 5000000;
  // the source of eligible characters.
  const src = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  print('Profiling a randomly generated $len-character text.');
  print('Elegible characters: "$src".');
  final index = Random();

  print('Start...');
  final watch = Stopwatch()..start();
  final dartText = randText(src, len, index);
  final elapsedDartTime = watch.elapsedMilliseconds;
  print('\nDart elapsed time....: $elapsedDartTime milliseconds');
  watch.stop();
  watch.reset();

  watch.start();
  final dartoosText = RandOf(src, len, index).value;
  final elapsedDartoosTime = watch.elapsedMilliseconds;
  print('Dartoos elapsed time.: $elapsedDartoosTime milliseconds');
  watch.stop();

  final ratio = (elapsedDartTime / elapsedDartoosTime).toStringAsFixed(2);
  print('Performance ratio....: $ratio (Dart time/Dartoos time)');
  print(
    'Are the generated texts the same length? ${dartText.length == dartoosText.length}',
  );
}

/// Common approach to generate random Strings in Dart.
String randText(String chars, int len, Random index) {
  final buffer = StringBuffer();
  for (var i = 0; i < len; ++i) {
    buffer.write(chars[index.nextInt(chars.length)]);
  }
  return buffer.toString();
}
