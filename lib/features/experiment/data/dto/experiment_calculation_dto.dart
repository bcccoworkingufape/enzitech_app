// 🌎 Project imports:
import '../../domain/entities/experiment_calculation_entity.dart';

extension ExperimentCalculationDto on ExperimentCalculationEntity {
  static ExperimentCalculationEntity fromJson(Map json) {
    return ExperimentCalculationEntity(
      results: List<num>.from(json['results']).map((e) => e).toList(),
      average: json['average'],
    );
  }

  Map toJson() {
    return {
      'results': results,
      'average': average,
    };
  }
}
