abstract class Failure implements Exception {
  Failure({this.message = "", this.key = ""});

  final dynamic key;
  final String message;
}

class ServerFailure extends Failure {
  ServerFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class NoNetworkFailure extends Failure {
  NoNetworkFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class ForbiddenFailure extends Failure {
  ForbiddenFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidOrMissingFieldFailure extends Failure {
  InvalidOrMissingFieldFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidDeviceIdFailure extends Failure {
  InvalidDeviceIdFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class UnprocessableEntity extends Failure {
  UnprocessableEntity({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidInputFailure extends Failure {
  InvalidInputFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class UserNotFoundOrWrongTokenFailure extends Failure {
  UserNotFoundOrWrongTokenFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class ExpiredTokenOrWrongUserFailure extends Failure {
  ExpiredTokenOrWrongUserFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class SessionNotFoundFailure extends Failure {
  SessionNotFoundFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class FieldsMismatchFailure extends Failure {
  FieldsMismatchFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidPinFailure extends Failure {
  InvalidPinFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidEmail extends Failure {
  InvalidEmail({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidPasswordRange extends Failure {
  InvalidPasswordRange({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidGoogleId extends Failure {
  InvalidGoogleId({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class NewEmailEqualsCurrentEmail extends Failure {
  NewEmailEqualsCurrentEmail({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InactiveUserFailure extends Failure {
  InactiveUserFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class NotFoundFailure extends Failure {
  NotFoundFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidCNPJ extends Failure {
  InvalidCNPJ({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class InvalidVerificationCode extends Failure {
  InvalidVerificationCode({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class EmailAlreadyInUse extends Failure {
  EmailAlreadyInUse({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class NoLocationNear extends Failure {
  NoLocationNear({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class ChangePasswordFailure extends Failure {
  ChangePasswordFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class CustomerNotFoundFailure extends Failure {
  CustomerNotFoundFailure({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class CustomerOwnedByAnotherSeller extends Failure {
  CustomerOwnedByAnotherSeller({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class CustomerAlreadyAddedInWallet extends Failure {
  CustomerAlreadyAddedInWallet({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class NoResultQuery extends Failure {
  NoResultQuery({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}

class UnknownError extends Failure {
  UnknownError({String message = "Erro desconhecido!", dynamic key = ""})
      : super(message: message, key: key);
}

class UnableToOpenURL extends Failure {
  UnableToOpenURL({String message = "", dynamic key = ""})
      : super(message: message, key: key);
}
