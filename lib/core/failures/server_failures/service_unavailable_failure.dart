// 🌎 Project imports:
import '../failure.dart';

// SC-500
class ServiceUnavailableFailure extends Failure {
  ServiceUnavailableFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
