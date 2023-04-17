// 🌎 Project imports:
import '../failure.dart';

// SC-503
class ServerFailure extends Failure {
  ServerFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
