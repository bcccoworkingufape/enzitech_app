// 🐦 Flutter imports:
import 'package:material_ui/material_ui.dart';

// 📦 Package imports:
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

// 🌎 Project imports:
import 'package:enzitech_app/core/data/service/secure_storage/secure_session_storage.dart';
import 'package:enzitech_app/core/domain/entities/http_driver_options.dart';
import 'package:enzitech_app/core/domain/entities/http_driver_response.dart';
import 'package:enzitech_app/core/domain/service/connection_checker/connection_checker.dart';
import 'package:enzitech_app/core/domain/service/http/http_service.dart';
import 'package:enzitech_app/core/domain/service/user_preferences/user_preferences_service.dart';
import 'package:enzitech_app/core/enums/enums.dart';
import 'package:enzitech_app/core/failures/failure.dart';
import 'package:enzitech_app/core/routing/routing.dart';
import 'package:enzitech_app/features/authentication/domain/entities/user_entity.dart';
import 'package:enzitech_app/features/authentication/domain/usecases/auth/auth_usecase.dart';
import 'package:enzitech_app/features/enzyme/domain/entities/enzyme_entity.dart';
import 'package:enzitech_app/features/enzyme/domain/usecases/enzymes_usecases.dart';
import 'package:enzitech_app/features/enzyme/presentation/viewmodel/enzymes_viewmodel.dart';
import 'package:enzitech_app/features/experiment/domain/entities/experiment_entity.dart';
import 'package:enzitech_app/features/experiment/domain/entities/experiment_pagination_entity.dart';
import 'package:enzitech_app/features/experiment/domain/entities/experiment_result_entity.dart';
import 'package:enzitech_app/features/experiment/domain/entities/repetition_entity.dart';
import 'package:enzitech_app/features/experiment/domain/usecases/experiments_usecases.dart';
import 'package:enzitech_app/features/experiment/presentation/viewmodel/experiments_viewmodel.dart';
import 'package:enzitech_app/features/main/domain/usecases/user_preferences_usecases.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/settings_viewmodel.dart';
import 'package:enzitech_app/features/main/presentation/viewmodel/splash_viewmodel.dart';
import 'package:enzitech_app/features/treatment/domain/entities/treatment_entity.dart';
import 'package:enzitech_app/features/treatment/domain/usecases/treatments_usecases.dart';
import 'package:enzitech_app/features/treatment/presentation/viewmodel/treatments_viewmodel.dart';

class FakeExperimentsUseCases implements ExperimentsUseCases {
  @override
  Future<Either<Failure, List<RepetitionEntity>>> getRepetitions({required String experimentId}) async =>
      const Right([]);

  @override
  Future<Either<Failure, RepetitionEntity>> previewRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, ExperimentEntity>> saveRepetition({
    required String experimentId,
    required String treatmentId,
    required String enzymeId,
    required int repetitionNumber,
    required double sample,
    required double whiteSample,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, ExperimentEntity>> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, ExperimentEntity>> updateExperiment({
    required String experimentId,
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> deleteExperiment(String id) => throw UnimplementedError();

  @override
  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id) => throw UnimplementedError();

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async => Right(ExperimentPaginationEntity(total: 0, experiments: const []));

  @override
  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId}) =>
      throw UnimplementedError();

  @override
  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity) async {}
}

class FakeEnzymesUseCases implements EnzymesUseCases {
  @override
  Future<Either<Failure, Unit>> deleteEnzyme(String id) => throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> createEnzyme({
    required String name,
    required double variableA,
    required double variableB,
    required String type,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymes() async => const Right([]);
}

class FakeTreatmentsUseCases implements TreatmentsUseCases {
  @override
  Future<Either<Failure, Unit>> deleteTreatment(String id) => throw UnimplementedError();

  @override
  Future<Either<Failure, TreatmentEntity>> createTreatment({required String name, required String description}) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<TreatmentEntity>>> getTreatments() async => const Right([]);
}

class FakeUserPreferencesUseCasesImpl implements UserPreferencesUseCases {
  final bool hasToken;

  FakeUserPreferencesUseCasesImpl({this.hasToken = false});

  @override
  Future<void> clearUser() async {}

  @override
  Future<Either<Failure, bool>> getExcludeConfirmation() async => const Right(true);

  @override
  Future<Either<Failure, bool>> getReplaceLanguage() async => const Right(false);

  @override
  Future<ThemeMode> getThemeMode() async => ThemeMode.system;

  @override
  Future<Either<Failure, UserEntity>> getUser() async => Right(
    UserEntity(token: 'token', name: 'Test User', email: 'user@example.com', id: '1', userType: UserTypeEnum.user),
  );

  @override
  Future<void> saveExcludeConfirmation(bool value) async {}

  @override
  Future<void> saveReplaceLanguage(bool value) async {}

  @override
  Future<void> saveThemeMode(ThemeMode theme) async {}
}

class FakeSecureSessionStorage extends SecureSessionStorage {
  final bool hasValidToken;

  FakeSecureSessionStorage({this.hasValidToken = false});

  @override
  Future<String?> readToken() async => hasValidToken ? 'token' : null;

  @override
  Future<bool> hasToken() async => hasValidToken;

  @override
  Future<void> migrateFromLegacyIfNeeded({
    required Future<String?> Function() legacyReader,
    Future<void> Function(String)? legacyClearer,
  }) async {}
}

class FakeConnectionChecker implements ConnectionChecker {
  @override
  Future<bool> hasInternetInternetConnection() async => true;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeUserPreferencesService implements UserPreferencesService {
  @override
  Future<void> removeToken() async {}

  @override
  Future<String?> getToken() async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('SplashViewmodel.resolveInitialRoute', () {
    test('should go to home when the app has a valid session token', () async {
      final experimentsViewmodel = ExperimentsViewmodel(FakeExperimentsUseCases(), FakeConnectionChecker());
      final enzymesViewmodel = EnzymesViewmodel(FakeEnzymesUseCases());
      final treatmentsViewmodel = TreatmentsViewmodel(FakeTreatmentsUseCases());
      final settingsViewmodel = SettingsViewmodel(
        FakeUserPreferencesUseCasesImpl(),
        FakeSecureSessionStorage(),
        FakeHttpService(),
        FakeAuthUseCase(),
      );

      final viewmodel = SplashViewmodel(
        experimentsViewmodel,
        enzymesViewmodel,
        treatmentsViewmodel,
        settingsViewmodel,
        FakeUserPreferencesService(),
        FakeSecureSessionStorage(hasValidToken: true),
        FakeHttpService(),
      );

      final nextRoute = await viewmodel.resolveInitialRoute();

      expect(nextRoute, Routing.home);
      expect(viewmodel.destinationRoute, Routing.home);
    });

    test('should go to login when there is no valid session token', () async {
      final experimentsViewmodel = ExperimentsViewmodel(FakeExperimentsUseCases(), FakeConnectionChecker());
      final enzymesViewmodel = EnzymesViewmodel(FakeEnzymesUseCases());
      final treatmentsViewmodel = TreatmentsViewmodel(FakeTreatmentsUseCases());
      final settingsViewmodel = SettingsViewmodel(
        FakeUserPreferencesUseCasesImpl(),
        FakeSecureSessionStorage(),
        FakeHttpService(),
        FakeAuthUseCase(),
      );

      final viewmodel = SplashViewmodel(
        experimentsViewmodel,
        enzymesViewmodel,
        treatmentsViewmodel,
        settingsViewmodel,
        FakeUserPreferencesService(),
        FakeSecureSessionStorage(hasValidToken: false),
        FakeHttpService(),
      );

      final nextRoute = await viewmodel.resolveInitialRoute();

      expect(nextRoute, Routing.login);
      expect(viewmodel.destinationRoute, Routing.login);
    });
  });
}

class FakeAuthUseCase implements AuthUseCase {
  @override
  Future<Either<Failure, Unit>> deleteAccount() async => const Right(unit);

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
  Future<Either<Failure, Unit>> verifyPin({required String email, required String token}) => throw UnimplementedError();

  @override
  Future<Either<Failure, Unit>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) => throw UnimplementedError();
}

class FakeHttpService implements HttpService {
  @override
  Future<void> setConfig({String? token}) async {}

  @override
  Future<void> clearSession() async {}

  @override
  Future<HttpDriverResponse> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
    Map<String, dynamic>? extraHeaders,
  }) => throw UnimplementedError();

  @override
  Future<HttpDriverResponse> getFile<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
  }) => throw UnimplementedError();

  @override
  Future<HttpDriverResponse> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) => throw UnimplementedError();

  @override
  Future<HttpDriverResponse> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) => throw UnimplementedError();

  @override
  Future<HttpDriverResponse> put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
  }) => throw UnimplementedError();

  @override
  Future<HttpDriverResponse> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
  }) => throw UnimplementedError();

  @override
  void resetContentType() {}

  @override
  Future<HttpDriverResponse> sendFile<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    HttpDriverOptions? options,
    HttpDriverProgressCallback? onReceiveProgress,
    HttpDriverProgressCallback? onSendProgress,
  }) => throw UnimplementedError();
}
