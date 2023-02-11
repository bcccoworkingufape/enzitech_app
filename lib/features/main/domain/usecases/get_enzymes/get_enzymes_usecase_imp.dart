import 'package:dartz/dartz.dart';
import '../../../../../core/failures/failure.dart';

import '../../entities/enzyme_entity.dart';
import '../../repositories/get_enzymes_repository.dart';
import 'get_enzymes_usecase.dart';

class GetEnzymesUseCaseImp implements GetEnzymesUseCase {
  final GetEnzymesRepository _getEnzymesRepository;

  GetEnzymesUseCaseImp(this._getEnzymesRepository);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call() async {
    return await _getEnzymesRepository.call();
  }
}
