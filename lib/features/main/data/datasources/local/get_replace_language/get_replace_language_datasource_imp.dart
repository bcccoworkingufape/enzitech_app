// 📦 Package imports:

import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../../../../../core/failures/failures.dart';
import '../../get_replace_language_datasource.dart';

class GetReplaceLanguageDataSourceImp extends GetReplaceLanguageDataSource {
  final UserPreferencesServices _userPreferencesServices;

  GetReplaceLanguageDataSourceImp(this._userPreferencesServices);

  @override
  Future<Either<Failure, bool>> call() async {
    try {
      var response = await _userPreferencesServices.getReplaceLanguage();
      return Right(response);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
