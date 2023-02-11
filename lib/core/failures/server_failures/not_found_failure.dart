import '../failure.dart';

// SC-404
class NotFoundFailure extends Failure {
  NotFoundFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
