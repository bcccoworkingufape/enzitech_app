class EnzymeEntity {
  String id;
  String name;
  double variableA;
  double variableB;
  String type;

  EnzymeEntity({
    required this.id,
    required this.name,
    required this.variableA,
    required this.variableB,
    required this.type,
  });

  @override
  String toString() {
    return "{id: $id, name: $name, variableA: $variableA, variableB: $variableB, type: $type}";
  }
}
