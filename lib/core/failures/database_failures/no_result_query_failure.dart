// 🌎 Project imports:
import '../failure.dart';

class NoResultQueryFailure extends Failure {
  NoResultQueryFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
