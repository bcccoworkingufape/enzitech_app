import '../failure.dart';

class InvalidGoogleIdFailure extends Failure {
  InvalidGoogleIdFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
