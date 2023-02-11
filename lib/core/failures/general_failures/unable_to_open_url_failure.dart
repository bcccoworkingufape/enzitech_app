import '../failure.dart';

class UnableToOpenUrlFailure extends Failure {
  UnableToOpenUrlFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
