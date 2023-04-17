// 🌎 Project imports:
import '../../domain/entities/experiment_calculation_entity.dart';

extension ExperimentCalculationDto on ExperimentCalculationEntity {
  static ExperimentCalculationEntity fromJson(Map json) {
    // print(json['results'].runtimeType);
    // print(json['results'][0].runtimeType);
    // // List<int> fetchedResultsAsInt = [];
    // List<double> fetchedResultsAsDouble = [];
    // if (json['results'][0].runtimeType is int) {
    //   fetchedResultsAsDouble =
    //       (json['results'] as List<int>).map((int i) => i.toDouble()).toList();
    // } else {
    //   fetchedResultsAsDouble =
    //       (json['results'] as List<double>).map((double d) => d).toList();
    // }
    // json['results'][0] is int
    //     ? fetchedResultsAsDouble =
    //         json['results'].map((int integer) => integer.toDouble()).toList()
    //     : fetchedResultsAsDouble =
    //         json['results'].map((double integer) => integer).toList();

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
