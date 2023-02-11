import '../failure.dart';

// SC-401
class ExpiredTokenOrWrongUserFailure extends Failure {
  ExpiredTokenOrWrongUserFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
