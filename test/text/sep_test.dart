import 'package:dartoos/src/text/sep.dart';
import 'package:test/test.dart';

void main() {
  group('Sep class', () {
    test('No separator', () {
      const none = Sep.none();
      expect(none(), '');
      expect('$none', '');
    });
    test('Space', () {
      const sp = Sep.sp();
      expect(sp(), ' ');
      expect('$sp', ' ');
    });
    test('Line Feed', () {
      const lf = Sep.lf();
      expect(lf(), '\n');
      expect('$lf', '\n');
    });
    test('New Line', () {
      const nl = Sep.nl();
      expect(nl(), '\n');
      expect('$nl', '\n');
    });
    test('Carriage Return', () {
      const cr = Sep.cr();
      expect(cr(), '\r');
      expect('$cr', '\r');
    });
    test('Carriage Return and Line Feed', () {
      const crlf = Sep.crlf();
      expect(crlf(), '\r\n');
      expect('$crlf', '\r\n');
    });
    test('Horizontal Tab', () {
      const tab = Sep.tab();
      expect(tab(), '\t');
      expect('$tab', '\t');
    });
    test('Vertical Tab', () {
      const vt = Sep.vt();
      expect(vt(), '\v');
      expect('$vt', '\v');
    });
    test('Form Feed', () {
      const ff = Sep.ff();
      expect(ff(), '\f');
      expect('$ff', '\f');
    });
    test('New Page', () {
      const np = Sep.np();
      expect(np(), '\f');
      expect('$np', '\f');
    });
    test('Whitespace Characters', () {
      const ws = Sep.ws();
      expect(ws(), ' \r\n\t\v\f');
      expect('$ws', ' \r\n\t\v\f');
    });
  });
}
