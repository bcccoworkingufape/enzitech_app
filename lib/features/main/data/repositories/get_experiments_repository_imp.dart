// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failure.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/entities/experiment_pagination_entity.dart';
import '../../domain/repositories/get_experiments_repository.dart';
import '../datasources/get_experiments_datasource.dart';
import '../datasources/get_treatments_datasource.dart';

class GetExperimentsRepositoryImp implements GetExperimentsRepository {
  final GetExperimentsDataSource _getExperimentsDataSource;

  GetExperimentsRepositoryImp(this._getExperimentsDataSource);

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> call(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    return await _getExperimentsDataSource(
      page,
      orderBy: orderBy,
      ordering: ordering,
      limit: limit,
      finished: finished,
    );
  }
}
