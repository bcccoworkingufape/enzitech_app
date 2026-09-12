// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:enzitech_app/core/data/service/secure_storage/secure_session_storage.dart';
import 'package:enzitech_app/core/domain/service/http/http_service.dart';
import 'package:enzitech_app/core/enums/enums.dart';
import 'package:enzitech_app/core/failures/failure.dart';
import 'package:enzitech_app/core/failures/server_failures/server_failure.dart';
import 'package:enzitech_app/features/authentication/domain/entities/user_entity.dart';
import 'package:enzitech_app/features/authentication/domain/usecases/auth/auth_usecase.dart';
import 'package:enzitech_app/features/main/domain/usecases/user_preferences_usecases.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/settings_viewmodel.dart';

class FakeAuthUseCase implements AuthUseCase {
  Either<Failure, Unit> deleteAccountResult = const Right(unit);
  int deleteAccountCalls = 0;

  @override
  Future<Either<Failure, Unit>> deleteAccount() async {
    deleteAccountCalls++;
    return deleteAccountResult;
  }

  @override
  Future<Either<Failure, UserEntity>> login({required String email, required String password}) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> createAccount({
    required String name,
    required String email,
    required String password,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> recoverPassword({required String email}) => throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> verifyPin({required String email, required String token}) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) => throw UnimplementedError();
}

class FakeUserPreferencesUseCases implements UserPreferencesUseCases {
  final UserEntity user;
  bool clearUserCalled = false;

  FakeUserPreferencesUseCases(this.user);

  @override
  Future<void> clearUser() async => clearUserCalled = true;

  @override
  Future<Either<Failure, UserEntity>> getUser() async => Right(user);

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async => const Right(true);

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async => const Right(false);

  @override
  Future<ThemeMode> getThemeMode() async => ThemeMode.system;

  @override
  Future<void> saveExcludeConfirmation(bool value) async {}

  @override
  Future<void> saveReplaceLanguage(bool value) async {}

  @override
  Future<void> saveThemeMode(ThemeMode theme) async {}
}

class FakeSecureSessionStorage implements SecureSessionStorage {
  bool removeTokenCalled = false;

  @override
  Future<void> removeToken() async => removeTokenCalled = true;

  @override
  Future<String?> readToken() async => null;

  @override
  Future<bool> hasToken() async => false;

  @override
  Future<void> writeToken(String token) async {}

  @override
  Future<void> migrateFromLegacyIfNeeded({
    required Future<String?> Function() legacyReader,
    Future<void> Function(String)? legacyClearer,
  }) async {}
}

class FakeHttpService implements HttpService {
  bool clearSessionCalled = false;

  @override
  Future<void> clearSession() async => clearSessionCalled = true;

  @override
  noSuchMethod(Invocation invocation) => throw UnimplementedError();
}

void main() {
  late FakeAuthUseCase authUseCase;
  late FakeUserPreferencesUseCases userPreferences;
  late FakeSecureSessionStorage secureStorage;
  late FakeHttpService httpService;
  late SettingsViewmodel viewmodel;

  final user = UserEntity(
    token: 'token',
    name: 'Pesquisador',
    email: 'pesquisador@enzitech.test',
    id: '1',
    userType: UserTypeEnum.user,
  );

  setUp(() {
    authUseCase = FakeAuthUseCase();
    userPreferences = FakeUserPreferencesUseCases(user);
    secureStorage = FakeSecureSessionStorage();
    httpService = FakeHttpService();
    viewmodel = SettingsViewmodel(userPreferences, secureStorage, httpService, authUseCase);
  });

  group('SettingsViewmodel.deleteAccount', () {
    test('Should clear the session and the user when the server confirms', () async {
      await viewmodel.loadAccount();
      expect(viewmodel.user, isNotNull);

      await viewmodel.deleteAccount();

      expect(authUseCase.deleteAccountCalls, 1);
      expect(viewmodel.state, StateEnum.success);
      expect(viewmodel.accountDeleted, isTrue);
      expect(viewmodel.user, isNull);
      expect(secureStorage.removeTokenCalled, isTrue);
      expect(httpService.clearSessionCalled, isTrue);
      expect(userPreferences.clearUserCalled, isTrue);
    });

    test('Should keep the session when the deletion fails', () async {
      authUseCase.deleteAccountResult = Left(ServerFailure(message: 'erro'));

      await viewmodel.loadAccount();
      await viewmodel.deleteAccount();

      expect(viewmodel.state, StateEnum.error);
      expect(viewmodel.failure, isA<ServerFailure>());
      expect(viewmodel.accountDeleted, isFalse);
      expect(viewmodel.user, isNotNull);
      expect(secureStorage.removeTokenCalled, isFalse);
      expect(httpService.clearSessionCalled, isFalse);
      expect(userPreferences.clearUserCalled, isFalse);
    });

    test('Should not flag the account as deleted before the request', () {
      expect(viewmodel.accountDeleted, isFalse);
    });
  });
}
