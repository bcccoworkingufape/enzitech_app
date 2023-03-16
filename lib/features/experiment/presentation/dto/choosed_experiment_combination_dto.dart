class ChoosedExperimentCombinationDTO {
  String? enzymeId;
  String? treatmentId;

  ChoosedExperimentCombinationDTO({
    this.enzymeId,
    this.treatmentId,
  });

  @override
  String toString() {
    return "{enzymeId: $enzymeId, treatmentId: $treatmentId}";
  }
}
