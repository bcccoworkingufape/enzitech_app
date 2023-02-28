// 🌎 Project imports:
import '../../repositories/save_exclude_confirmation_repository.dart';
import 'save_exclude_confirmation_usecase.dart';

class SaveExcludeConfirmationUseCaseImp
    implements SaveExcludeConfirmationUseCase {
  final SaveExcludeConfirmationRepository _saveExcludeConfirmationRepository;

  SaveExcludeConfirmationUseCaseImp(this._saveExcludeConfirmationRepository);

  @override
  Future<void> call(bool value) async {
    return await _saveExcludeConfirmationRepository(value);
  }
}
