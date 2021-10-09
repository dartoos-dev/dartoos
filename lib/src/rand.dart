import 'dart:math';

import 'text.dart';

/// Randomized text.
class Rand extends Text {
  /// Random text having [src] as the source of eligible characters, [len] as
  /// the length, and [index] as the index randomizer.
  Rand(int len, Future<String> src, [Random? index])
      : super(
          Future(() async {
            final buffer = StringBuffer();
            final randIndex = index ?? Random();
            final chars = await src;
            for (int count = 0; count < len; count++) {
              buffer.write(chars[randIndex.nextInt(chars.length)]);
            }
            return buffer.toString();
          }),
        );

  /// Random digits [0–9] of length [len].
  Rand.dig(int len, [Random? index]) : this.str(len, '0123456789', index);

  /// Random hex digits [0–9a-f] of length [len].
  Rand.hex(int len, [Random? index]) : this.str(len, '0123456789abcdef', index);

  /// Random string of length [len] from [src].
  Rand.str(int len, String src, [Random? index])
      : this(len, Future.value(src), index);
}
