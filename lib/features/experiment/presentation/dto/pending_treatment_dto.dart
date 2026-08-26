class PendingTreatmentDTO {
  String name;
  String description;

  PendingTreatmentDTO({required this.name, required this.description});

  @override
  String toString() => "{name: $name, description: $description}";
}
