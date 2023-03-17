class ChoosedExperimentCombinationDTO {
  String? enzymeId;
  String? enzymeName;
  String? treatmentId;
  String? treatmentName;

  ChoosedExperimentCombinationDTO({
    this.enzymeId,
    this.enzymeName,
    this.treatmentId,
    this.treatmentName,
  });

  @override
  String toString() {
    return "{enzymeId: $enzymeId, enzymeName: $enzymeName, treatmentId: $treatmentId}, treatmentName: $treatmentName}";
  }
}
