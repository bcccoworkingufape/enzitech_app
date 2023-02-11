import '../failure.dart';

class EmailAlreadyInUseFailure extends Failure {
  EmailAlreadyInUseFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
