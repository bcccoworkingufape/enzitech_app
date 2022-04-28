import 'dart:async';

import 'global_error_observer.dart';

typedef ListenType<T> = StreamSubscription<T> Function(void Function(T event)?,
    {bool? cancelOnError, void Function()? onDone, Function? onError});

abstract class IViewmodel {
  bool get inLoading;
  Exception? get error;
  void setError(Exception error);
  void setLoading(bool status);
  void clearError();
  ListenType<Exception?> get onError;
  ListenType<bool> get onLoading;
  void dispose();
}

class Viewmodel extends IViewmodel {
  Exception? _lastError;
  bool _inLoading = false;

  final _controllerError = StreamController<Exception?>.broadcast();
  final _controllerLoading = StreamController<bool>.broadcast();

  @override
  ListenType<Exception?> get onError => _controllerError.stream.listen;
  @override
  ListenType<bool> get onLoading => _controllerLoading.stream.listen;

  @override
  void setError(Exception error) {
    _lastError = error;
    if (!_controllerError.isClosed) _controllerError.add(error);
    GlobalErrorObserver.dispatch(error);
  }

  @override
  void clearError() {
    _lastError = null;
    if (!_controllerError.isClosed) _controllerError.add(null);
  }

  @override
  void setLoading(bool status) {
    _inLoading = status;

    if (!_controllerLoading.isClosed) {
      _controllerLoading.add(status);
    }
  }

  @override
  bool get inLoading => _inLoading;

  @override
  Exception? get error => _lastError;

  @override
  void dispose() {
    _controllerError.close();
    _controllerLoading.close();
  }
}
