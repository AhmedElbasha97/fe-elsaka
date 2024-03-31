
import 'dart:convert';

List<CarCategoryModel> carCategoryModelFromJson(String str) => List<CarCategoryModel>.from(json.decode(str).map((x) => CarCategoryModel.fromJson(x)));

String carCategoryModelToJson(List<CarCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarCategoryModel {
  String? modelId;
  String? titleAr;
  String? titleEn;
  String? brandId;

  CarCategoryModel({
    this.modelId,
    this.titleAr,
    this.titleEn,
    this.brandId,
  });

  factory CarCategoryModel.fromJson(Map<String, dynamic> json) => CarCategoryModel(
    modelId: json["model_id"],
    titleAr: json["title_ar"],
    titleEn: json["title_en"],
    brandId: json["brand_id"],
  );

  Map<String, dynamic> toJson() => {
    "model_id": modelId,
    "title_ar": titleAr,
    "title_en": titleEn,
    "brand_id": brandId,
  };
}
