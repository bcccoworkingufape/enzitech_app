// 🌎 Project imports:
import '../failure.dart';

// SC-403
class ForbiddenFailure extends Failure {
  ForbiddenFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
