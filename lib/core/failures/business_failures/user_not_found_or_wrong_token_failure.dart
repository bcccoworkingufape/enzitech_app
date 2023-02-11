import '../failure.dart';

class UserNotFoundOrWrongTokenFailure extends Failure {
  UserNotFoundOrWrongTokenFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
