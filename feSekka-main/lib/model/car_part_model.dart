import 'dart:convert';

List<CarPartModel> carPartModelFromJson(String str) => List<CarPartModel>.from(json.decode(str).map((x) => CarPartModel.fromJson(x)));

String carPartModelToJson(List<CarPartModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CarPartModel {
  String? partsId;
  String? titleAr;
  String? titleEn;

  CarPartModel({
    this.partsId,
    this.titleAr,
    this.titleEn,
  });

  factory CarPartModel.fromJson(Map<String, dynamic> json) => CarPartModel(
    partsId: json["parts_id"],
    titleAr: json["title_ar"],
    titleEn: json["title_en"],
  );

  Map<String, dynamic> toJson() => {
    "parts_id": partsId,
    "title_ar": titleAr,
    "title_en": titleEn,
  };
}
