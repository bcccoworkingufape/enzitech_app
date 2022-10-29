// 🎯 Dart imports:
import 'dart:convert';

// 🌎 Project imports:
import 'package:enzitech_app/src/shared/business/domain/entities/experiment_pagination_entity.dart';
import 'package:enzitech_app/src/shared/business/infra/models/experiment_model.dart';

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

  ExperimentPaginationEntity toEntity() {
    return ExperimentPaginationEntity(
      total: total,
      experiments: experiments.map((x) => x.toEntity()).toList(),
    );
  }

  factory ExperimentPaginationModel.fromEntity(
      ExperimentPaginationEntity entity) {
    return ExperimentPaginationModel(
      total: entity.total,
      experiments:
          entity.experiments.map((x) => ExperimentModel.fromEntity(x)).toList(),
    );
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
