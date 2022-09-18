class CarType {
  CarType({
    this.carsTypesId,
    this.name,
  });

  String? carsTypesId;
  String? name;

  factory CarType.fromJson(Map<String, dynamic> json) => CarType(
        carsTypesId:
            json["cars_types_id"] == null ? null : json["cars_types_id"],
        name: json["name"] == null ? null : json["name"],
      );
}
