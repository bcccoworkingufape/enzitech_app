// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/key_value/key_value_service.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../domain/entities/experiment_pagination_entity.dart';
import '../../../dto/experiment_pagination_dto.dart';
import '../../get_experiments_datasource.dart';
import 'get_experiments_local_datasource_decorator.dart';

class GetExperimentsDataSourceDecoratorImp
    extends GetExperimentsDataSourceDecorator {
  final KeyValueService _keyValueService;

  GetExperimentsDataSourceDecoratorImp(
      GetExperimentsDataSource getExperimentsDataSource, this._keyValueService)
      : super(getExperimentsDataSource);

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> call(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    return (await super(
      page,
      orderBy: orderBy,
      ordering: ordering,
      limit: limit,
      finished: finished,
    ))
        .fold(
      (error) async => error is ExpiredTokenOrWrongUserFailure
          ? Left(error)
          : await _getInCache(),
      (result) {
        // _saveInCache(result);
        return Right(result);
      },
    );
  }

  @override
  saveInCache(ExperimentPaginationEntity experimentPaginationEntity) async {
    String json = jsonEncode(experimentPaginationEntity.toJson()).toString();

    _keyValueService.setString('experiments_cache', json);
  }

  Future<Either<Failure, ExperimentPaginationEntity>> _getInCache() async {
    try {
      var treatmentsJsonString =
          await _keyValueService.getString('experiments_cache');

      if (treatmentsJsonString == null) {
        throw NoResultQueryFailure(message: "a listagem de experimentos");
      }

      var json = jsonDecode(treatmentsJsonString);
      var experimentPagination = ExperimentPaginationDto.fromJson(json);

      return Right(experimentPagination);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
