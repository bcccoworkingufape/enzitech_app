// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/get_exclude_confirmation_repository.dart';
import '../get_replace_language/get_replace_language.dart';

class GetReplaceLanguageUseCaseImp implements GetReplaceLanguageUseCase {
  final GetExcludeConfirmationRepository _getExcludeConfirmationRepository;

  GetReplaceLanguageUseCaseImp(this._getExcludeConfirmationRepository);

  @override
  Future<Either<Failure, bool>> call() async {
    return await _getExcludeConfirmationRepository();
  }
}
