// 🌎 Project imports:
import '../failure.dart';

// SC-400
class InvalidOrMissingFieldFailure extends Failure {
  InvalidOrMissingFieldFailure({super.message, super.key});
}
