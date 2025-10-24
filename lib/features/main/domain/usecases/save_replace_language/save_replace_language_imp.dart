// 📦 Package imports:

// 🌎 Project imports:
import '../../repositories/save_exclude_confirmation_repository.dart';
import 'save_replace_language.dart';

class SaveReplaceLanguageUseCaseImp implements SaveReplaceLanguageUseCase {
  final SaveExcludeConfirmationRepository _saveExcludeConfirmationRepository;

  SaveReplaceLanguageUseCaseImp(this._saveExcludeConfirmationRepository);

  @override
  Future<void> call(bool value) async {
    return await _saveExcludeConfirmationRepository(value);
  }
}
