class CarModel {
  CarModel({
    this.carsModelsId,
    this.name,
  });

  String? carsModelsId;
  String? name;

  factory CarModel.fromJson(Map<String, dynamic> json) => CarModel(
        carsModelsId:
            json["cars_models_id"] == null ? null : json["cars_models_id"],
        name: json["name"] == null ? null : json["name"],
      );
}
