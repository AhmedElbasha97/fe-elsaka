import 'dart:convert';

List<CarBrandModel> carBrandModelFromJson(String str) => List<CarBrandModel>.from(json.decode(str).map((x) => CarBrandModel.fromJson(x)));

String carBrandModelToJson(List<CarBrandModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarBrandModel {
  String? brandId;
  String? titleAr;
  String? titleEn;

  CarBrandModel({
    this.brandId,
    this.titleAr,
    this.titleEn,
  });

  factory CarBrandModel.fromJson(Map<String, dynamic> json) => CarBrandModel(
    brandId: json["brand_id"],
    titleAr: json["title_ar"],
    titleEn: json["title_en"],
  );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "title_ar": titleAr,
    "title_en": titleEn,
  };
}
