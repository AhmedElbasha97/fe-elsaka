class PartQuailty {
  PartQuailty({
    this.carsPartsQualityId,
    this.name,
  });

  String? carsPartsQualityId;
  String? name;

  factory PartQuailty.fromJson(Map<String, dynamic> json) => PartQuailty(
        carsPartsQualityId: json["cars_parts_quality_id"] == null
            ? null
            : json["cars_parts_quality_id"],
        name: json["name"] == null ? null : json["name"],
      );
}
