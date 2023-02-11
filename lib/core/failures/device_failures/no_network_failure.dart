import '../failures.dart';

class NoNetworkFailure extends Failure {
  NoNetworkFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
