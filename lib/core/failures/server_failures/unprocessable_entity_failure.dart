// 🌎 Project imports:
import '../failure.dart';

// SC-422
class UnprocessableEntityFailure extends Failure {
  UnprocessableEntityFailure({super.message, super.key});
}
