class CarYear {
  CarYear({
    this.carsYearsId,
    this.name,
  });

  String? carsYearsId;
  String? name;

  factory CarYear.fromJson(Map<String, dynamic> json) => CarYear(
        carsYearsId:
            json["cars_years_id"] == null ? null : json["cars_years_id"],
        name: json["name"] == null ? null : json["name"],
      );
}
