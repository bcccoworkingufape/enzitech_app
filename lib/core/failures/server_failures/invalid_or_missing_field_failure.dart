// 🌎 Project imports:
import '../failure.dart';

// SC-400
class InvalidOrMissingFieldFailure extends Failure {
  InvalidOrMissingFieldFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
