// 🌎 Project imports:
import '../failure.dart';

//! SC-426
class InvalidDeviceIdFailure extends Failure {
  InvalidDeviceIdFailure({super.message, super.key});
}
