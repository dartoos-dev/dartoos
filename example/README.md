# Dartoos Showcase

How to use Dartoos effectively.

## Getting Started

From the root directory of this project, enter the following commands:

```shell
  cd example/
  dart run  radix/hex_of_bytes_benchmark.dart
```

This launchs the benchmark of the `HexOfBytes` class, which in turn converts an
array of bytes to its hexadecimal text representation. The end result is a small
report that compares the performance of a typical Dart implementation of such a
conversion (bytes to hexadecimal) with the performance of the conversion
provided by the Dartoos package.

Likewise, you can issue similar commands to launch other benchmarks programs.
