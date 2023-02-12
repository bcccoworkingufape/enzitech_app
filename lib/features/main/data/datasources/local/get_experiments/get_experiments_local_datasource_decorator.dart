// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/failures/failures.dart';
import '../../../../domain/entities/experiment_entity.dart';
import '../../../../domain/entities/experiment_pagination_entity.dart';
import '../../get_experiments_datasource.dart';

abstract class GetExperimentsDataSourceDecorator
    implements GetExperimentsDataSource {
  final GetExperimentsDataSource _getEnzymesDataSource;

  GetExperimentsDataSourceDecorator(this._getEnzymesDataSource);

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> call(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) =>
      _getEnzymesDataSource(
        page,
        orderBy: orderBy,
        ordering: ordering,
        limit: limit,
        finished: finished,
      );

  @override
  Future<void> saveInCache(
      ExperimentPaginationEntity experimentPaginationEntity);
}
