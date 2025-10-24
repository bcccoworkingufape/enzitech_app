// 📦 Package imports:

// 🌎 Project imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../save_replace_language_datasource.dart';

class SaveReplaceLanguageDataSourceImp extends SaveReplaceLanguageDataSource {
  final UserPreferencesServices _userPreferencesServices;

  SaveReplaceLanguageDataSourceImp(this._userPreferencesServices);

  @override
  Future<void> call(bool value) async {
    await _userPreferencesServices.saveReplaceLanguage(value);
  }
}
