// 🌎 Project imports:
import '../../../../shared/extensions/extensions.dart';
import '../../domain/entities/experiment_calculation_entity.dart';

extension ExperimentCalculationDto on ExperimentCalculationEntity {
  static ExperimentCalculationEntity fromJson(Map json) {
    return ExperimentCalculationEntity(
      results: List<double>.from(json['results'])
          .map((e) => e.toPrecision(5))
          .toList(),
      average: json['average'] is double
          ? json['average']
          : double.parse(json['average']).toPrecision(5),
    );
  }

  Map toJson() {
    return {
      'results': results,
      'average': average,
    };
  }
}
