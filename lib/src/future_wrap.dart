import 'dart:async';

/// Represents a Future<T> value.

/// Object-oriented approach: instead of returning a value,
/// subclasses will themselves be the value.
abstract class FutureWrap<T> implements Future<T> {
  /// Main constructor.
  FutureWrap(FutureOr<T> origin) : _origin = Future.value(origin);

  /// The encapsulated original Future.
  final Future<T> _origin;

  @override
  Stream<T> asStream() => _origin.asStream();

  @override
  Future<T> catchError(Function onError, {bool Function(Object)? test}) =>
      _origin.catchError(onError, test: test);

  @override
  Future<R> then<R>(FutureOr<R> Function(T) onValue, {Function? onError}) =>
      _origin.then(onValue, onError: onError);

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      _origin.timeout(timeLimit, onTimeout: onTimeout);

  @override
  Future<T> whenComplete(FutureOr Function() action) =>
      _origin.whenComplete(action);
}
