// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../core/failures/failures.dart';
import '../../domain/entities/experiment_pagination_entity.dart';

abstract class GetExperimentsDataSource {
  Future<Either<Failure, ExperimentPaginationEntity>> call(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  });

  Future<void> saveInCache(
      ExperimentPaginationEntity experimentPaginationEntity);
}
