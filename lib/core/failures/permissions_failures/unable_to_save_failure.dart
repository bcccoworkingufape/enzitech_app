// 🌎 Project imports:
import '../failures.dart';

class UnableToSaveFailure extends Failure {
  UnableToSaveFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
