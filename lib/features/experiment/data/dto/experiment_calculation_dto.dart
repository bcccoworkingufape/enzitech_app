// 🌎 Project imports:
import 'dart:convert';

import '../../domain/entities/experiment_calculation_entity.dart';

extension ExperimentCalculationDto on ExperimentCalculationEntity {
  static ExperimentCalculationEntity fromJson(Map json) {
    return ExperimentCalculationEntity(
      results: (jsonDecode(json['results']) as List)
          .map((i) => double.parse(i))
          .toList(),
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
