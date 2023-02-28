// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../../core/failures/failures.dart';
import '../../get_exclude_confirmation_datasource.dart';

class GetExcludeConfirmationLocalDataSourceImp
    extends GetExcludeConfirmationDataSource {
  final UserPreferencesServices _userPreferencesServices;

  GetExcludeConfirmationLocalDataSourceImp(this._userPreferencesServices);

  @override
  Future<Either<Failure, bool>> call() async {
    try {
      var response = await _userPreferencesServices.getExcludeConfirmation();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
