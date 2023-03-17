// 🌎 Project imports:
import '../../domain/entities/experiment_calculation_entity.dart';

extension ExperimentCalculationDto on ExperimentCalculationEntity {
  static ExperimentCalculationEntity fromJson(Map json) {
    return ExperimentCalculationEntity(
      results: List<double>.from(json['results']),
      average: json['average'] is double
          ? json['average']
          : double.parse(json['average']),
    );
  }

  Map toJson() {
    return {
      'results': results,
      'average': average,
    };
  }
}
