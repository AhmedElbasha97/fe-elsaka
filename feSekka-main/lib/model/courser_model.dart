// To parse this JSON data, do
//
//     final courserModel = courserModelFromJson(jsonString);

import 'dart:convert';

import 'package:FeSekka/model/category.dart';


List<CourserModel> courserModelFromJson(String str) => List<CourserModel>.from(json.decode(str).map((x) => CourserModel.fromJson(x)));


class CourserModel {
  String? sliderId;
  String? nameAr;
  String? nameEn;
  String? providerId;
  String? titleAr;
  String? titleEn;
  dynamic rate;
  String? lat;
  String? long;
  String? facebook;
  String? insgram;
  String? youtube;
  String? whatsapp;
  String? whatsappClicks;
  String? mobile;
  String? mobileClicks;
  String? snapchat;
  String? detailsAr;
  String? detailsEn;
  String? refmainCategory;
  String? garage;
  String? picpath;
  String? picpathEn;
  String? shareurl;
  List<Sub>? sub;
  List<MainCategories>? mainCategory;
  int? orders;
  List<WrokHours>? wrokHours;
  List<String>? slider;

  CourserModel({
    this.sliderId,
    this.nameAr,
    this.nameEn,
    this.providerId,
    this.titleAr,
    this.titleEn,
    this.rate,
    this.lat,
    this.long,
    this.facebook,
    this.insgram,
    this.youtube,
    this.whatsapp,
    this.whatsappClicks,
    this.mobile,
    this.mobileClicks,
    this.snapchat,
    this.detailsAr,
    this.detailsEn,
    this.refmainCategory,
    this.garage,
    this.picpath,
    this.picpathEn,
    this.shareurl,
    this.sub,
    this.mainCategory,
    this.orders,
    this.wrokHours,
    this.slider,
  });

  factory CourserModel.fromJson(Map<String, dynamic> json) => CourserModel(
    sliderId: json["slider_id"],
    nameAr: json["name_ar"],
    nameEn: json["name_en"],
    providerId: json["provider_id"],
    titleAr: json["title_ar"],
    titleEn: json["title_en"],
    rate: json["rate"],
    lat: json["lat"],
    long: json["long"],
    facebook: json["facebook"],
    insgram: json["insgram"],
    youtube: json["youtube"],
    whatsapp: json["whatsapp"],
    whatsappClicks: json["whatsapp_clicks"],
    mobile: json["mobile"],
    mobileClicks: json["mobile_clicks"],
    snapchat: json["snapchat"],
    detailsAr: json["details_ar"],
    detailsEn: json["details_en"],
    refmainCategory: json["refmain_category"],
    garage: json["garage"],
    picpath: json["picpath"],
    picpathEn: json["picpath_en"],
    shareurl: json["shareurl"],
    sub: json["sub"] == null ? [] : List<Sub>.from(json["sub"]!.map((x) => x)),
    mainCategory: json["main_category"] == null ? [] : List<MainCategories>.from(json["main_category"]!.map((x) => MainCategories.fromJson(x))),
    orders: json["orders"],
    wrokHours: json["wrok_hours"] == null ? [] : List<WrokHours>.from(json["wrok_hours"]!.map((x) => x)),
    slider: json["slider"] == null ? [] : List<String>.from(json["slider"]!.map((x) => x)),
  );


}

class MainCategories {
  String? titlear;
  String? titleen;

  MainCategories({
    this.titlear,
    this.titleen,
  });

  factory MainCategories.fromJson(Map<String, dynamic> json) => MainCategories(
    titlear: json["titlear"],
    titleen: json["titleen"],
  );

  Map<String, dynamic> toJson() => {
    "titlear": titlear,
    "titleen": titleen,
  };
}
