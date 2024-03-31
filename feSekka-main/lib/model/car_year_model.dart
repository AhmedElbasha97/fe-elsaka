

import 'dart:convert';

List<CarYearModel> carYearModelFromJson(String str) => List<CarYearModel>.from(json.decode(str).map((x) => CarYearModel.fromJson(x)));

String carYearModelToJson(List<CarYearModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarYearModel {
  String? yearId;
  String? year;

  CarYearModel({
    this.yearId,
    this.year,
  });

  factory CarYearModel.fromJson(Map<String, dynamic> json) => CarYearModel(
    yearId: json["year_id"],
    year: json["year"],
  );

  Map<String, dynamic> toJson() => {
    "year_id": yearId,
    "year": year,
  };
}
