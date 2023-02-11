import '../failure.dart';

class InvalidVerificationCodeFailure extends Failure {
  InvalidVerificationCodeFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
