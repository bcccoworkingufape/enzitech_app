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
    const mock = '''
{
   "result":[
      {
         "enzyme":{
            "id":"2e1ccc63-b4c8-4fd6-92d0-af9933aa405b",
            "name":"Urease",
            "type":"Urease",
            "formula":"μg NH4-N g-1 dwt 2h-1",
            "variableA":"0.2876",
            "variableB":"0.0075",
            "duration":"2",
            "weightSample":"1.25",
            "weightGround":"0.92",
            "size":"1.25"
         },
         "processes":[
            {
               "process":{
                  "id":"98e539a1-42ac-4168-a61e-b4c085a11cc9",
                  "name":"Tratamento com adubo",
                  "description":"Solo adubado"
               },
               "results":[
                  {
                     "repetitionId":1,
                     "sample":0.731,
                     "whiteSample":0.536,
                     "differenceBetweenSamples":0.195,
                     "variableA":0.2876,
                     "variableB":0.0075,
                     "curve":0.6519471488,
                     "correctionFactor":0.92,
                     "time":2,
                     "volume":1.25,
                     "weightSample":1.25,
                     "result":7.0864
                  },
                  {
                     "repetitionId":2,
                     "sample":0.826,
                     "whiteSample":0.684,
                     "differenceBetweenSamples":0.142,
                     "variableA":0.2876,
                     "variableB":0.0075,
                     "curve":0.4676634214,
                     "correctionFactor":0.92,
                     "time":2,
                     "volume":1.25,
                     "weightSample":1.25,
                     "result":5.0833
                  }
               ]
            },
            {
               "process":{
                  "id":"98e539a1-42ac-4168-a61e-b4c085a11cc9",
                  "name":"Tratamento com braquiária",
                  "description":"Solo fértil"
               },
               "results":[
                  {
                     "repetitionId":3,
                     "sample":1.273,
                     "whiteSample":0.696,
                     "differenceBetweenSamples":0.577,
                     "variableA":0.2876,
                     "variableB":0.0075,
                     "curve":1.980180807,
                     "correctionFactor":0.92,
                     "time":2,
                     "volume":1.25,
                     "weightSample":1.25,
                     "result":21.5237
                  },
                  {
                     "repetitionId":4,
                     "sample":0.849,
                     "whiteSample":0.606,
                     "differenceBetweenSamples":0.243,
                     "variableA":0.2876,
                     "variableB":0.0075,
                     "curve":0.8188456189,
                     "correctionFactor":0.92,
                     "time":2,
                     "volume":1.25,
                     "weightSample":1.25,
                     "result":8.9005
                  }
               ]
            }
         ]
      },
      {
         "enzyme":{
            "id":"37e2b8d8-85ba-41c5-ab72-0bc6db879169",
            "name":"Aryl",
            "type":"Aryl",
            "formula":"µg PNS g-1 solo h-1",
            "variableA":"0.0139",
            "variableB":"0.0088",
            "duration":"1",
            "weightSample":"0.5",
            "weightGround":"0.98",
            "size":"5.0"
         },
         "processes":[
            {
               "process":{
                  "id":"98e539a1-42ac-4168-a61e-b4c085a11cc9",
                  "name":"Tratamento com adubo",
                  "description":"Solo adubado"
               },
               "results":[
                  {
                     "repetitionId":1,
                     "sample":2.096,
                     "whiteSample":0.824,
                     "differenceBetweenSamples":1.272,
                     "variableA":"0.0139",
                     "variableB":"0.0088",
                     "curve":90.87769784,
                     "correctionFactor":0.98,
                     "time":1,
                     "volume":5.0,
                     "weightSample":0.5,
                     "result":331.963001
                  },
                  {
                     "repetitionId":2,
                     "sample":2.096,
                     "whiteSample":0.824,
                     "differenceBetweenSamples":1.272,
                     "variableA":"0.0139",
                     "variableB":"0.0088",
                     "curve":90.87769784,
                     "correctionFactor":0.98,
                     "time":1,
                     "volume":5.0,
                     "weightSample":0.5,
                     "result":927.3234474
                  }
               ]
            },
            {
               "process":{
                  "id":"98e539a1-42ac-4168-a61e-b4c085a11cc9",
                  "name":"Tratamento com braquiária",
                  "description":"Solo fértil"
               },
               "results":[
                  {
                     "repetitionId":3,
                     "sample":2.31,
                     "whiteSample":1.035,
                     "differenceBetweenSamples":1.275,
                     "variableA":"0.0139",
                     "variableB":"0.0088",
                     "curve":91.09352518,
                     "correctionFactor":0.98,
                     "time":1,
                     "volume":5.0,
                     "weightSample":0.5,
                     "result":929.5257671
                  },
                  {
                     "repetitionId":4,
                     "sample":1.78,
                     "whiteSample":1.605,
                     "differenceBetweenSamples":0.175,
                     "variableA":"0.0139",
                     "variableB":"0.0088",
                     "curve":11.95683453,
                     "correctionFactor":0.98,
                     "time":1,
                     "volume":5.0,
                     "weightSample":0.5,
                     "result":122.0085156
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
