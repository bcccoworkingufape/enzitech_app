// 🌎 Project imports:
import '../failure.dart';

class InvalidPasswordRangeFailure extends Failure {
  InvalidPasswordRangeFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
