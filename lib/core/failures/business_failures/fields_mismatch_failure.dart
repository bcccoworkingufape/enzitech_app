import '../failure.dart';

class FieldsMismatchFailure extends Failure {
  FieldsMismatchFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
