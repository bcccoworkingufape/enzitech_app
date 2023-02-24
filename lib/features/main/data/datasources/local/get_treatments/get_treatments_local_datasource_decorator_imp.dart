// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../../core/domain/service/key_value/key_value_service.dart';
import '../../../../../../core/failures/failures.dart';
import '../../../../domain/entities/treatment_entity.dart';
import '../../../dto/treatment_dto.dart';
import '../../get_treatments_datasource.dart';
import 'get_treatments_local_datasource_decorator.dart';

class GetTreatmentsDataSourceDecoratorImp
    extends GetTreatmentsDataSourceDecorator {
  final KeyValueService _keyValueService;

  GetTreatmentsDataSourceDecoratorImp(
      GetTreatmentsDataSource getTreatmentsDataSource, this._keyValueService)
      : super(getTreatmentsDataSource);

  @override
  Future<Either<Failure, List<TreatmentEntity>>> call() async {
    return (await super()).fold(
      (error) async => error is ExpiredTokenOrWrongUserFailure
          ? Left(error)
          : await _getInCache(),
      (result) {
        _saveInCache(result);
        return Right(result);
      },
    );
  }

  _saveInCache(List<TreatmentEntity> treatments) async {
    String json = jsonEncode(
      treatments.map((i) => i.toJson()).toList(),
    ).toString();

    _keyValueService.setString('treatments_cache', json);
  }

  Future<Either<Failure, List<TreatmentEntity>>> _getInCache() async {
    try {
      var treatmentsJsonString =
          await _keyValueService.getString('treatments_cache');

      if (treatmentsJsonString == null) {
        throw NoResultQueryFailure(message: "a listagem de tratamentos");
      }

      var json = jsonDecode(treatmentsJsonString);
      var treatments =
          (json as List).map((e) => TreatmentDto.fromJson(e)).toList();

      return Right(treatments);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
