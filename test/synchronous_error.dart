import "dart:async";

class SynchronousError<T> implements Future<T> {

  final Object _error;

  SynchronousError(this._error);

  @override
  Stream<T> asStream() {
    final StreamController controller = StreamController<T>();
    controller.addError(_error);
    controller.close();
    return controller.stream;
  }

  @override
  Future<T> catchError(Function onError, { bool test(dynamic error) }) {
    onError(_error);
    return Completer<T>().future;
  }

  @override
  Future<E> then<E>(dynamic f(T value), { Function onError }) {
    return SynchronousError<E>(_error);
  }

  @override
  Future<T> timeout(Duration timeLimit, { dynamic onTimeout() }) {
    return Future<T>.error(_error).timeout(timeLimit, onTimeout: onTimeout);
  }

  @override
  Future<T> whenComplete(dynamic action()) {
    try {
      return this;
    } catch (e, stack) {
      return Future<T>.error(e, stack);
    }
  }
}
