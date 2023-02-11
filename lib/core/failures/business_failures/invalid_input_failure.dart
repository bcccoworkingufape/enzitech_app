import '../failure.dart';

class InvalidInputFailure extends Failure {
  InvalidInputFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
