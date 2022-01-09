# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Dart Package Versioning](https://dart.dev/tools/pub/versioning).

## [Unreleased]

### Added

- _'Contribute'_ section to README — [39](https://github.com/dartoos-dev/dartoos/issues/39).

## [0.4.0] - 2021-12-16

### Added

- classes RandText, RandTextSrc, and RandTextLen — [29](https://github.com/dartoos-dev/dartoos/issues/29).

### Changed

- rename class Rand to RandOf — **Breaking Change**.

### Removed

- RandDig and RandHex classes — **Breaking Change**s.

## [0.3.1] - 2021-12-15

### Added

- specific exception for base64 decoding errors — [26](https://github.com/dartoos-dev/dartoos/issues/26)

## [0.3.0] - 2021-12-09

### Added

- file "func.dart" with the definition of the functional interfaces.
- cryptographic package with hash functions sha224, sha256, sha384, sha512,
  along with their related Hmac function (Hash-based message authentication
  code)
- tabular text of ordinary text and data. The data can be represented with
  binary, octal, decimal, or hexadecimal notation.
- radix package: a set of classes for converting numeric data into its textual
  representation in a given radix (numeric base).
- bit package: a set of classes for bit-related operations.
- several benchmarks comparing Dartoos to the Dart sdk or other third-party
  packages like _Crypto_.

### Changed

- No class extends FutureWrap any more — **BREAKING CHANGE**.
- A general reorganization of the package directory structures.

### Removed

- FutureWrap — **BREAKING CHANGE**.

## [0.2.0] - 2021-10-15

### Added

- Base64 and Base64Url encoding schemes —
  [12](https://github.com/dartoos-dev/dartoos/issues/12)
- Base64Decode class for decoding base64-encoded text —
  [19](https://github.com/dartoos-dev/dartoos/issues/19).
- Base64Norm class for normalizing base64-encoded texts.
- Dartoos base64-encoding/decoding benchmark executable in 'example'.

### Changed

- Rand class now accepts not only plain values but also Futures
  as a source of characters.
- BytesOf constructors now accepts both plain values and Futures.

### Removed

- Rand.str constructor — **Breaking Change**.
- FutureWrap.value constructor — **Breaking Change**.

## [0.1.0] - 2021-10-05

### Added

- FutureWrap class: instead of returning a value, subclasses are the value.
- Text abstract class
- Rand class for generating random string patterns —
  [9](https://g]]]ithub.com/dartoos-dev/dartoos/issues/9).
