// 📦 Package imports:
import 'dart:convert';

import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_calculation_entity.dart';
import '../../dto/experiment_calculation_dto.dart';
import '../calculate_experiment_datasource.dart';

class CalculateExperimentRemoteDataSourceImp
    implements CalculateExperimentDataSource {
  final HttpService _httpService;
  CalculateExperimentRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentCalculationEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  }) async {
    try {
      var list = jsonDecode(jsonEncode(listOfExperimentData));
      List<Map<String, double>> listWithoutIds = [];
      for (var i in list) {
        // print(i);
        // print(i.runtimeType);
        i.remove('_id');

        listWithoutIds.add({
          'sample':
              i['sample'] is String ? double.parse(i['sample']) : i['sample'],
          'whiteSample': i['whiteSample'] is String
              ? double.parse(i['whiteSample'])
              : i['whiteSample']
        });
      }

      var response = await _httpService.post(
        API.REQUEST_CALCULATE_EXPERIMENTS(experimentId),
        data: {
          "enzyme": enzymeId,
          "process": treatmentID,
          "experimentData": listWithoutIds,
        },
      );

      var result = ExperimentCalculationDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      if (e is TypeError) {
        return Left(TypeFailure(message: e.toString()));
      }
      return Left(e as Failure);
    }
  }
}
