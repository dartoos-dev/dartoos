# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Dart Package Versioning](https://dart.dev/tools/pub/versioning).

## [Unreleased]

## [0.2.0] - 2021-10-15

### Added

- Base64 and Base64Url encoding schemes —
  [12](https://github.com/dartoos-dev/dartoos/issues/12)
- Base64Decode class for decoding base64-encoded text —
  [19](https://github.com/dartoos-dev/dartoos/issues/19).
- Base64Norm class for normalizing base64-encoded texts.
- Dartoos base64-encoding/decoding benchmark executable in 'example'.

### Changed

- Rand class accept as source of characters both plain and Future values.
- BytesOf constructors accept both plain and Future values.

### Removed

- Rand.str constructor — **Breaking Change**.
- FutureWrap.value constructor — **Breaking Change**.

## [0.1.0] - 2021-10-05

### Added

- FutureWrap class: instead of returning a value, subclasses are the value.
- Text abstract class
- Rand class for generating random string patterns —
  [9](https://g]]]ithub.com/dartoos-dev/dartoos/issues/9).
