// 🌎 Project imports:
import '../../../../shared/extensions/extensions.dart';
import '../../domain/entities/experiment_repetition_result_entity.dart';

extension ExperimentRepetitionResultDto on ExperimentRepetitionResultEntity {
  static ExperimentRepetitionResultEntity fromJson(Map json) {
    return ExperimentRepetitionResultEntity(
      repetitionId: json['repetitionId'].toString(),
      sample: json['sample'] is double
          ? json['sample']
          : double.parse(json['sample']).toPrecision(5),
      whiteSample: json['whiteSample'] is double
          ? json['whiteSample']
          : double.parse(json['whiteSample']).toPrecision(5),
      differenceBetweenSamples: json['differenceBetweenSamples'] is double
          ? json['differenceBetweenSamples']
          : double.parse(json['differenceBetweenSamples']).toPrecision(5),
      variableA: json['variableA'] is double
          ? json['variableA']
          : double.parse(json['variableA']).toPrecision(5),
      variableB: json['variableB'] is double
          ? json['variableB']
          : double.parse(json['variableB']).toPrecision(5),
      curve: json['curve'] is double
          ? json['curve']
          : double.parse(json['curve']).toPrecision(5),
      correctionFactor: json['correctionFactor'] is double
          ? json['correctionFactor']
          : double.parse(json['correctionFactor']).toPrecision(5),
      time: json['time'] is int ? json['time'] : int.parse(json['time']),
      volume: json['volume'] is double
          ? json['volume']
          : double.parse(json['volume']).toPrecision(5),
      weightSample: json['weightSample'] is double
          ? json['weightSample']
          : double.parse(json['weightSample']).toPrecision(5),
      result: json['result'] is double
          ? json['result']
          : double.parse(json['result']).toPrecision(5),
    );
  }

  Map toJson() {
    return {
      'repetitionId': repetitionId,
      'sample': sample,
      'whiteSample': whiteSample,
      'differenceBetweenSamples': differenceBetweenSamples,
      'variableA': variableA,
      'variableB': variableB,
      'curve': curve,
      'correctionFactor': correctionFactor,
      'time': time,
      'volume': volume,
      'weightSample': weightSample,
      'result': result,
    };
  }
}
