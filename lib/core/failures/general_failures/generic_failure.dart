// 🌎 Project imports:
import '../failure.dart';

class GenericFailure extends Failure {
  GenericFailure({String message = "Erro desconhecido!", dynamic key = ""})
      : super(message: message, key: key);
}
