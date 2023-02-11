// 🌎 Project imports:
import '../failure.dart';

class InvalidEmailFailure extends Failure {
  InvalidEmailFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
