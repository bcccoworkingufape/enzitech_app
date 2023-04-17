// 🌎 Project imports:
import '../failure.dart';

class SessionNotFoundFailure extends Failure {
  SessionNotFoundFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
