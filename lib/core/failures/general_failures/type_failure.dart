// 🌎 Project imports:
import '../failure.dart';

class TypeFailure extends Failure {
  TypeFailure({String message = "Erro de tipo", dynamic key = ""})
      : super(message: message, key: key);
}
