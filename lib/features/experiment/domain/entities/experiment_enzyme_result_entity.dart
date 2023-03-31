import 'experiment_treatment_result_entity.dart';

class ExperimentEnzymeResultEntity {
    ExperimentEnzymeResultEntity({
        required this.enzymeName,
        required this.treatments,
    });

    final String enzymeName;
    final List<ExperimentTreatmentResultEntity> treatments;
}