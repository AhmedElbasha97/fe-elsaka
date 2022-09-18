class PartType {
  PartType({
    this.carsPartsTypesId,
    this.name,
  });

  String? carsPartsTypesId;
  String? name;

  factory PartType.fromJson(Map<String, dynamic> json) => PartType(
        carsPartsTypesId: json["cars_parts_types_id"] == null
            ? null
            : json["cars_parts_types_id"],
        name: json["name"] == null ? null : json["name"],
      );
}
