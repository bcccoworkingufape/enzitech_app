// 🌎 Project imports:
import '../../domain/entities/repetition_entity.dart';

extension RepetitionDto on RepetitionEntity {
  static RepetitionEntity fromJson(Map json) {
    return RepetitionEntity(
      id: json['id'],
      treatmentId: json['treatmentId'],
      treatmentName: json['treatmentName'],
      enzymeId: json['enzymeId'],
      enzymeName: json['enzymeName'],
      repetitionNumber: json['repetitionNumber'],
      status: json['status'],
      sample: (json['sample'] as num?)?.toDouble(),
      whiteSample: (json['whiteSample'] as num?)?.toDouble(),
      differenceBetweenSamples: (json['differenceBetweenSamples'] as num?)?.toDouble(),
      curve: (json['curve'] as num?)?.toDouble(),
      result: (json['result'] as num?)?.toDouble(),
    );
  }
}
