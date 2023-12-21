// 🎯 Dart imports:
import 'dart:convert';

// 📦 Package imports:
import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../dto/experiment_dto.dart';
import '../save_result_datasource.dart';

class SaveResultRemoteDataSourceImp implements SaveResultDataSource {
  final HttpService _httpService;
  SaveResultRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentEntity>> call({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
    required List<num> results,
    required num average,
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
        API.REQUEST_SAVE_RESULT_EXPERIMENTS(experimentId),
        data: {
          "enzyme": enzymeId,
          "process": treatmentID,
          "experimentData": listWithoutIds,
          "results": results,
          "average": average
        },
      );
      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }
}
