import '../failure.dart';

class InactiveUserFailure extends Failure {
  InactiveUserFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
