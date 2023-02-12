// 🌎 Project imports:
import '../../data/dto/experiment_dto.dart';
import '../../domain/entities/experiment_pagination_entity.dart';
import '../../domain/entities/experiment_entity.dart';

extension ExperimentPaginationDto on ExperimentPaginationEntity {
  static ExperimentPaginationEntity fromJson(Map json) {
    return ExperimentPaginationEntity(
      total: json['total'],
      experiments: List<ExperimentEntity>.from(
        json['experiments'].map(
          (x) => ExperimentDto.fromJson(x),
        ),
      ),
    );
  }

  Map toJson() {
    return {
      'total': total,
      'experiments': experiments.map((x) => x.toJson()).toList(),
    };
  }
}
