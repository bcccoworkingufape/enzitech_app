// 📦 Package imports:
import 'package:dartz/dartz.dart';

import '../../../../../../core/failures/failures.dart';
import '../../../../domain/entities/experiment_pagination_entity.dart';
import '../../get_experiments_datasource.dart';

// 🌎 Project imports:


abstract class GetExperimentsDataSourceDecorator
    implements GetExperimentsDataSource {
  final GetExperimentsDataSource _getExperimentsDataSource;

  GetExperimentsDataSourceDecorator(this._getExperimentsDataSource);

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> call(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) =>
      _getExperimentsDataSource(
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
