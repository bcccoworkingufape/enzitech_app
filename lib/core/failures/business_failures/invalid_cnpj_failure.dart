// 🌎 Project imports:
import '../failure.dart';

class InvalidCNPJFailure extends Failure {
  InvalidCNPJFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
