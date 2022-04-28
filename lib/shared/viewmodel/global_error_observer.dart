typedef StateObsListener = Function(Exception state);

class GlobalErrorObserver {
  static StateObsListener? _listener;
  static set listen(StateObsListener listener) => _listener = listener;

  static void dispatch(Exception error) {
    if (_listener != null) {
      _listener!(error);
    }
  }
}
