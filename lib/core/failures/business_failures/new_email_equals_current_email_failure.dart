// 🌎 Project imports:
import '../failure.dart';

class NewEmailEqualsCurrentEmailFailure extends Failure {
  NewEmailEqualsCurrentEmailFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
