// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/models/experiment_model.dart';

class ExperimentPaginationModel {
  int total;
  List<ExperimentModel> experiments;

  ExperimentPaginationModel({
    required this.total,
    required this.experiments,
  });

  Map<String, dynamic> toMap() {
    return {
      'total': total,
      'experiments': experiments.map((x) => x.toMap()).toList(),
    };
  }

  factory ExperimentPaginationModel.fromMap(Map<String, dynamic> map) {
    return ExperimentPaginationModel(
      total: map['total'],
      experiments: List<ExperimentModel>.from(
          map['experiments']?.map((x) => ExperimentModel.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExperimentPaginationModel.fromJson(String source) =>
      ExperimentPaginationModel.fromMap(json.decode(source));
}
