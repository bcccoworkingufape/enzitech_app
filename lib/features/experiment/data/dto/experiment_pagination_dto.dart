// 🌎 Project imports:
import '../../data/dto/experiment_dto.dart';
import '../../domain/entities/experiment_entity.dart';
import '../../domain/entities/experiment_pagination_entity.dart';

extension ExperimentPaginationDto on ExperimentPaginationEntity {
  static ExperimentPaginationEntity fromJson(Map json) {
    int extractTotal() {
      if (json['page'] != null && json['page']['totalElements'] != null) {
        return json['page']['totalElements'];
      }
      return json['total'] ?? json['totalElements'] ?? 0;
    }

    List<dynamic> contentList = json['content'] ?? json['experiments'] ?? [];

    return ExperimentPaginationEntity(
      total: extractTotal(),
      experiments: List<ExperimentEntity>.from(contentList.map((x) => ExperimentDto.fromJson(x))),
    );
  }
  
  Map toJson() {
    return {'total': total, 'experiments': experiments.map((x) => x.toJson()).toList()};
  }
}