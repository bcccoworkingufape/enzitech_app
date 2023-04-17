// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/enzyme_entity.dart';
import '../../domain/repositories/get_enzymes_repository.dart';
import '../datasources/get_enzymes_datasource.dart';

class GetEnzymesRepositoryImp implements GetEnzymesRepository {
  final GetEnzymesDataSource _getEnzymesDataSource;

  GetEnzymesRepositoryImp(this._getEnzymesDataSource);

  @override
  Future<Either<Failure, List<EnzymeEntity>>> call() async {
    return await _getEnzymesDataSource();
  }
}
