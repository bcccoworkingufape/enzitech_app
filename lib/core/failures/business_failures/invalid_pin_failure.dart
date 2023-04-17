// 🌎 Project imports:
import '../failure.dart';

class InvalidPinFailure extends Failure {
  InvalidPinFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
