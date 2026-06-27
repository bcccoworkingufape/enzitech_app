// ðŸŽ¯ Dart imports:
import 'dart:convert';

// ðŸ“¦ Package imports:
import 'package:dartz/dartz.dart';

// ðŸŒŽ Project imports:
import '../../../../../core/domain/service/http/http_service.dart';
import '../../../../../core/failures/failures.dart';
import '../../../../../shared/utils/api.dart';
import '../../../../enzyme/data/dto/enzyme_dto.dart';
import '../../../../enzyme/domain/entities/enzyme_entity.dart';
import '../../../domain/entities/experiment_calculation_entity.dart';
import '../../../domain/entities/experiment_entity.dart';
import '../../../domain/entities/experiment_pagination_entity.dart';
import '../../../domain/entities/experiment_result_entity.dart';
import '../../dto/experiment_calculation_dto.dart';
import '../../dto/experiment_dto.dart';
import '../../dto/experiment_pagination_dto.dart';
import '../../dto/experiment_result_dto.dart';
import '../experiments_datasource.dart';

class ExperimentsRemoteDataSourceImp implements ExperimentsDataSource {
  final HttpService _httpService;

  ExperimentsRemoteDataSourceImp(this._httpService);

  @override
  Future<Either<Failure, ExperimentCalculationEntity>> calculateExperiment({
    required String experimentId,
    required String enzymeId,
    required String treatmentID,
    required List<Map<String, dynamic>> listOfExperimentData,
  }) async {
    try {
      var list = jsonDecode(jsonEncode(listOfExperimentData));
      List<Map<String, double>> listWithoutIds = [];
      for (var i in list) {
        i.remove('_id');

        listWithoutIds.add({
          'sample': i['sample'] is String ? double.parse(i['sample']) : i['sample'],
          'whiteSample': i['whiteSample'] is String ? double.parse(i['whiteSample']) : i['whiteSample'],
        });
      }

      var response = await _httpService.post(
        API.REQUEST_CALCULATE_EXPERIMENTS(experimentId),
        data: {"enzyme": enzymeId, "process": treatmentID, "experimentData": listWithoutIds},
      );

      var result = ExperimentCalculationDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      if (e is TypeError) {
        return Left(TypeFailure());
      }
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentEntity>> createExperiment({
    required String name,
    required String description,
    required int repetitions,
    required List<String> treatmentsIDs,
    required List<EnzymeEntity> enzymes,
  }) async {
    try {
      List<Map> experimentsEnzymes = enzymes.map((enzyme) => enzyme.toJsonAsExperimentEnzyme()).toList();

      var response = await _httpService.post(
        API.REQUEST_EXPERIMENTS,
        data: {
          "name": name,
          "description": description,
          "repetitions": repetitions,
          "processes": treatmentsIDs,
          "experimentsEnzymes": experimentsEnzymes,
        },
      );

      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteExperiment(String id) async {
    try {
      await _httpService.delete(API.REQUEST_EXPERIMENTS_WITH_ID(id));
      return const Right(unit);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, List<EnzymeEntity>>> getEnzymesRemainingInExperiment({
    required String experimentId,
    required String treatmentId,
  }) async {
    try {
      var response = await _httpService.post(
        API.REQUEST_ENZYMES_REMAINING_IN_EXPERIMENT(experimentId),
        data: {"process": treatmentId},
      );

      var result = (response.data["enzymes"] as List).map((e) => EnzymeDto.fromJson(e)).toList();

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentEntity>> getExperimentById(String id) async {
    try {
      var response = await _httpService.get(API.REQUEST_EXPERIMENTS_WITH_ID(id));

      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentPaginationEntity>> getExperiments(
    int page, {
    String? orderBy,
    String? ordering,
    int? limit,
    bool? finished,
  }) async {
    try {
      var addOrderBy = orderBy != null ? "&orderBy=$orderBy" : "";
      var addOrdering = ordering != null ? "&ordering=$ordering" : "";
      var addLimit = limit != null ? "&limit=$limit" : "";
      var addFinished = finished != null ? "&finished=$finished" : "";

      var response = await _httpService.get(
        '${API.REQUEST_EXPERIMENTS}?page=$page$addOrderBy$addOrdering$addLimit$addFinished',
      );

      var result = ExperimentPaginationDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentResultEntity>> getResult({required String experimentId}) async {
    try {
      var response = await _httpService.get(API.REQUEST_GET_RESULT_EXPERIMENTS(experimentId));

      var result = ExperimentResultDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  @override
  Future<Either<Failure, ExperimentEntity>> saveResult({
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
        i.remove('_id');

        listWithoutIds.add({
          'sample': i['sample'] is String ? double.parse(i['sample']) : i['sample'],
          'whiteSample': i['whiteSample'] is String ? double.parse(i['whiteSample']) : i['whiteSample'],
        });
      }

      var response = await _httpService.post(
        API.REQUEST_SAVE_RESULT_EXPERIMENTS(experimentId),
        data: {
          "enzyme": enzymeId,
          "process": treatmentID,
          "experimentData": listWithoutIds,
          "results": results,
          "average": average,
        },
      );
      var result = ExperimentDto.fromJson(response.data);

      return Right(result);
    } catch (e) {
      return Left(e as Failure);
    }
  }

  /// Do not implement or use this method here!
  /// If you want to use storeInCache do using the local repository
  @override
  Future<void> storeExperimentsInCache(ExperimentPaginationEntity experimentPaginationEntity) {
    throw UnimplementedError();
  }
}


