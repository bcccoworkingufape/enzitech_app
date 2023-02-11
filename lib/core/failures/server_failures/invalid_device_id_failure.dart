// 🌎 Project imports:
import '../failure.dart';

// SC-426
class InvalidDeviceIdFailure extends Failure {
  InvalidDeviceIdFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
