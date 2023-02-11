// 🌎 Project imports:
import '../failure.dart';

// SC-422
class UnprocessableEntityFailure extends Failure {
  UnprocessableEntityFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
