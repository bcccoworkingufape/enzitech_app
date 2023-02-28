// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/get_exclude_confirmation_repository.dart';
import 'get_exclude_confirmation_usecase.dart';

class GetExcludeConfirmationUseCaseImp
    implements GetExcludeConfirmationUseCase {
  final GetExcludeConfirmationRepository _getExcludeConfirmationRepository;

  GetExcludeConfirmationUseCaseImp(this._getExcludeConfirmationRepository);

  @override
  Future<Either<Failure, bool>> call() async {
    return await _getExcludeConfirmationRepository();
  }
}
