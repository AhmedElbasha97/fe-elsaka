import 'dart:convert';

List<ZonesModel> zonesModelFromJson(String str) => List<ZonesModel>.from(json.decode(str).map((x) => ZonesModel.fromJson(x)));

String zonesModelToJson(List<ZonesModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ZonesModel {
  String? zoneId;
  String? titleAr;
  String? titleEn;

  ZonesModel({
    this.zoneId,
    this.titleAr,
    this.titleEn,
  });

  factory ZonesModel.fromJson(Map<String, dynamic> json) => ZonesModel(
    zoneId: json["zone_id"],
    titleAr: json["title_ar"],
    titleEn: json["title_en"],
  );

  Map<String, dynamic> toJson() => {
    "zone_id": zoneId,
    "title_ar": titleAr,
    "title_en": titleEn,
  };
}