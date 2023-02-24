// 📦 Package imports:
import '../../../../../../core/domain/service/user_preferences/user_preferences_service.dart';
import '../../save_exclude_confirmation_datasource.dart';

class SaveExcludeConfirmationLocalDataSourceImp
    extends SaveExcludeConfirmationDataSource {
  final UserPreferencesServices _userPreferencesServices;

  SaveExcludeConfirmationLocalDataSourceImp(this._userPreferencesServices);

  @override
  Future<void> call(bool value) async {
    await _userPreferencesServices.saveExcludeConfirmation(value);
  }
}
