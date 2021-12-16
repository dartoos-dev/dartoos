import 'package:dartoos/byte.dart';
import 'package:dartoos/crypto.dart';
import 'package:test/test.dart';

/// Test vectors from RCF 4231
///
/// See also:
/// - [Test Vectors](https://datatracker.ietf.org/doc/html/rfc4231)
void main() {
  group("20-byte key and data = 'Hi There'", () {
    // 20-byte key.
    final key = BytesOf.list(List<int>.filled(20, 0x0b)).value;
    final data = BytesOf.utf8('Hi There').value;
    test('hmac224', () {
      final hmac224 = HexHmac.sha224(key);
      expect(
        hmac224(data),
        '896fb1128abbdf196832107cd49df33f47b4b1169912ba4f53684b22',
      );
    });
    test('hmac256', () {
      final hmac256 = HexHmac.sha256(key);
      expect(
        hmac256(data),
        'b0344c61d8db38535ca8afceaf0bf12b881dc200c9833da726e9376c2e32cff7',
      );
    });
    test('hmac384', () {
      final hmac384 = HexHmac.sha384(key);
      expect(
        hmac384(data),
        '''afd03944d84895626b0825f4ab46907f15f9dadbe4101ec682aa034c7cebc59cfaea9ea9076ede7f4af152e8b2fa9cb6''',
      );
    });
    test('hmac512', () {
      final hmac512 = HexHmac.sha512(key);
      expect(
        hmac512(data),
        '''87aa7cdea5ef619d4ff0b4241a1d6cb02379f4e2ce4ec2787ad0b30545e17cdedaa833b7d6b8a702038b274eaea3f4e4be9d914eeb61f1702e696c203a126854''',
      );
    });
  });

  group('Key shorter than the length of the HMAC output', () {
    // 20-byte key.
    final key = BytesOf.utf8('Jefe').value;
    final data = BytesOf.utf8('what do ya want for nothing?').value;
    test('hmac224', () {
      expect(
        HexHmac.sha224(key).value(data),
        'a30e01098bc6dbbf45690f3a7e9e6d0f8bbea2a39e6148008fd05e44',
      );
    });
    test('hmac256', () {
      expect(
        HexHmac.sha256(key).value(data),
        '5bdcc146bf60754e6a042426089575c75a003f089d2739839dec58b964ec3843',
      );
    });
    test('hmac384', () {
      expect(
        HexHmac.sha384(key).value(data),
        '''af45d2e376484031617f78d2b58a6b1b9c7ef464f5a01b47e42ec3736322445e8e2240ca5e69e2c78b3239ecfab21649''',
      );
    });
    test('hmac512', () {
      expect(
        HexHmac.sha512(key).value(data),
        '''164b7a7bfcf819e2e395fbe73b56e0a387bd64222e831fd610270cd7ea2505549758bf75c05a994a6d034f65f8f0e6fdcaeab1a34d4a6b4b636e070a38bce737''',
      );
    });
  });

  group('Combined length of key and data larger than 64 bytes', () {
    final key = BytesOf.filled(20, 0xaa).value;
    final data = BytesOf.filled(50, 0xdd).value;
    test('hmac224', () {
      expect(
        HexHmac.sha224(key).value(data),
        '7fb3cb3588c6c1f6ffa9694d7d6ad2649365b0c1f65d69d1ec8333ea',
      );
    });
    test('hmac256', () {
      expect(
        HexHmac.sha256(key).value(data),
        '773ea91e36800e46854db8ebd09181a72959098b3ef8c122d9635514ced565fe',
      );
    });
    test('hmac384', () {
      expect(
        HexHmac.sha384(key).value(data),
        '''88062608d3e6ad8a0aa2ace014c8a86f0aa635d947ac9febe83ef4e55966144b2a5ab39dc13814b94e3ab6e101a34f27''',
      );
    });
    test('hmac512', () {
      expect(
        HexHmac.sha512(key).value(data),
        '''fa73b0089d56a284efb0f0756c890be9b1b5dbdd8ee81a3655f83e33b2279d39bf3e848279a722c806b485a47e67c807b946a337bee8942674278859e13292fb''',
      );
    });
  });
  group('key larger than 128 bytes', () {
    final key = BytesOf.filled(131, 0xaa).value;
    final data =
        BytesOf.utf8('Test Using Larger Than Block-Size Key - Hash Key First')
            .value;
    test('hmac224', () {
      expect(
        HexHmac.sha224(key).value(data),
        '95e9a0db962095adaebe9b2d6f0dbce2d499f112f2d2b7273fa6870e',
      );
    });
    test('hmac256', () {
      expect(
        HexHmac.sha256(key).value(data),
        '60e431591ee0b67f0d8a26aacbf5b77f8e0bc6213728c5140546040f0ee37f54',
      );
    });
    test('hmac384', () {
      expect(
        HexHmac.sha384(key).value(data),
        '''4ece084485813e9088d2c63a041bc5b44f9ef1012a2b588f3cd11f05033ac4c60c2ef6ab4030fe8296248df163f44952''',
      );
    });
    test('hmac512', () {
      expect(
        HexHmac.sha512(key).value(data),
        '''80b24263c7c1a3ebb71493c1dd7be8b49b46d1f41b4aeec1121b013783f8f3526b56d037e05f2598bd0fd2215d6a1e5295e64f73f63f0aec8b915a985d786598''',
      );
    });
  });
  group('key and data larger than 128 bytes', () {
    final key = BytesOf.filled(131, 0xaa).value;
    final data = BytesOf.utf8(
      '''This is a test using a larger than block-size key and a larger than block-size data. The key needs to be hashed before being used by the HMAC algorithm.''',
    ).value;
    test('hmac224', () {
      expect(
        HexHmac.sha224(key).value(data),
        '3a854166ac5d9f023f54d517d0b39dbd946770db9c2b95c9f6f565d1',
      );
    });
    test('hmac256', () {
      expect(
        HexHmac.sha256(key).value(data),
        '9b09ffa71b942fcb27635fbcd5b0e944bfdc63644f0713938a7f51535c3a35e2',
      );
    });
    test('hmac384', () {
      expect(
        HexHmac.sha384(key).value(data),
        '''6617178e941f020d351e2f254e8fd32c602420feb0b8fb9adccebb82461e99c5a678cc31e799176d3860e6110c46523e''',
      );
    });
    test('hmac512', () {
      expect(
        HexHmac.sha512(key).value(data),
        '''e37b6a775dc87dbaa4dfa9f96e5e3ffddebd71f8867289865df5a32d20cdc944b6022cac3c4982b10d5eeb55c3e4de15134676fb6de0446065c97440fa8c6a58''',
      );
    });
  });
}
