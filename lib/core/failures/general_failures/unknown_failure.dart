import '../failure.dart';

class UnknownFailure extends Failure {
  UnknownFailure({String message = "Erro desconhecido!", dynamic key = ""})
      : super(message: message, key: key);
}
