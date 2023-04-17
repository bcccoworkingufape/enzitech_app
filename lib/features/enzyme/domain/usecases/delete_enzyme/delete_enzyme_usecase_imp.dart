// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/failures/failure.dart';
import '../../repositories/delete_enzyme_repository.dart';
import 'delete_enzyme_usecase.dart';

class DeleteEnzymeUseCaseImp implements DeleteEnzymeUseCase {
  final DeleteEnzymeRepository _deleteEnzymeRepository;

  DeleteEnzymeUseCaseImp(
    this._deleteEnzymeRepository,
  );

  @override
  Future<Either<Failure, Unit>> call(String id) async {
    return await _deleteEnzymeRepository.call(id);
  }
}
