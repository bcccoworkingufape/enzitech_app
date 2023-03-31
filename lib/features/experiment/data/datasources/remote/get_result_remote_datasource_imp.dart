// 📦 Package imports:
import 'dart:convert';

import 'package:dartz/dartz.dart';

// 🌎 Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failure.dart';
import '../../../../../shared/utils/api.dart';
import '../../../domain/entities/experiment_result_entity.dart';
import '../../dto/experiment_result_dto.dart';
import '../get_result_datasource.dart';

class GetResultRemoteDataSourceImp implements GetResultDataSource {
  final HttpService _httpService;
  GetResultRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentResultEntity>> call({
    required String experimentId,
  }) async {
    // try {
    var response = await _httpService.get(
      API.REQUEST_GET_RESULT_EXPERIMENTS(experimentId),
    );

    // TODO: Remover mock
    const mock =
        '''
{
	"result": [
        {
            "enzymeName": "Urease",
            "processes": [
                {
                    "processName": "Tratamento com braquiária",
                    "results": [
                        {
                            "repetitionId": 1,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        },
                        {
                            "repetitionId": 2,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        }
                    ]
                },
                {
                    "processName": "Soja em monocultivo",
                    "results": [
                        {
                            "repetitionId": 3,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        },
                        {
                            "repetitionId": 4,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        }
                    ]
                }
            ]
        },
        {
            "enzymeName": "Aryl",
            "processes": [
                {
                    "processName": "Tratamento com braquiária",
                    "results": [
                        {
                            "repetitionId": 1,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        },
                        {
                            "repetitionId": 2,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        }
                    ]
                },
                {
                    "processName": "Soja em monocultivo",
                    "results": [
                        {
                            "repetitionId": 3,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        },
                        {
                            "repetitionId": 4,
                            "sample": 0.732,
                            "whiteSample": 0.155,
                            "differenceBetweenSamples": 0.577,
                            "variableA": 0.0139,
                            "variableB": 0.0088,
                            "curve": 40.87769784,
                            "correctionFactor": 0.98,
                            "time": 1,
                            "volume": 5.1,
                            "weightSample": 0.5,
                            "result": 417.1194
                        }
                    ]
                }
            ]
        }
    ]
}
''';

    var result = ExperimentResultDto.fromJson(jsonDecode(mock));
    // var result = ExperimentResultDto.fromJson(response.data);

    return Right(result);
    // } catch (e) {
    //   return Left(e as Failure);
    // }
  }
}
