class TreatmentEntity {
  String id;
  String name;
  String description;
  DateTime? createdAt;
  DateTime? updatedAt;

  TreatmentEntity({
    required this.id,
    required this.name,
    required this.description,
    this.createdAt,
    this.updatedAt,
  });
}
