import 'dart:convert';

List<ProviderRequestListModel> providerRequestListModelFromJson(String str) => List<ProviderRequestListModel>.from(json.decode(str).map((x) => ProviderRequestListModel.fromJson(x)));

String providerRequestListModelToJson(List<ProviderRequestListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProviderRequestListModel {
  String? orderId;
  String? type;
  String? isNew;
  String? message;
  String? created;
  String? userId;
  String? userName;
  String? userEmail;
  String? userMobile;
  String? brandId;
  String? brandNameAr;
  String? brandNameEn;
  String? modelId;
  String? modelNameAr;
  String? modelNameEn;
  String? partId;
  String? partNameAr;
  String? partlNameEn;
  String? countryId;
  String? countryNameAr;
  String? countryNameEn;
  String? mainCategoryId;
  String? mainCategoryNameAr;
  String? mainCategoryNameEn;
  String? yearId;
  String? year;
  String? picpath;

  ProviderRequestListModel({
    this.orderId,
    this.type,
    this.isNew,
    this.message,
    this.created,
    this.userId,
    this.userName,
    this.userEmail,
    this.userMobile,
    this.brandId,
    this.brandNameAr,
    this.brandNameEn,
    this.modelId,
    this.modelNameAr,
    this.modelNameEn,
    this.partId,
    this.partNameAr,
    this.partlNameEn,
    this.countryId,
    this.countryNameAr,
    this.countryNameEn,
    this.mainCategoryId,
    this.mainCategoryNameAr,
    this.mainCategoryNameEn,
    this.yearId,
    this.year,
    this.picpath,
  });

  factory ProviderRequestListModel.fromJson(Map<String, dynamic> json) => ProviderRequestListModel(
    orderId: json["order_id"],
    type: json["type"],
    isNew: json["is_new"],
    message: json["message"],
    created: json["created"],
    userId: json["user_id"],
    userName: json["user_name"],
    userEmail: json["user_email"],
    userMobile: json["user_mobile"],
    brandId: json["brand_id"],
    brandNameAr: json["brand_name_ar"],
    brandNameEn: json["brand_name_en"],
    modelId: json["model_id"],
    modelNameAr: json["model_name_ar"],
    modelNameEn: json["model_name_en"],
    partId: json["part_id"],
    partNameAr: json["part_name_ar"],
    partlNameEn: json["partl_name_en"],
    countryId: json["country_id"],
    countryNameAr: json["country_name_ar"],
    countryNameEn: json["country_name_en"],
    mainCategoryId: json["main_category_id"],
    mainCategoryNameAr: json["main_category_name_ar"],
    mainCategoryNameEn: json["main_category_name_en"],
    yearId: json["year_id"],
    year: json["year"],
    picpath: json["picpath"],
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "type": type,
    "is_new": isNew,
    "message": message,
    "created":created,
    "user_id": userId,
    "user_name": userName,
    "user_email": userEmail,
    "user_mobile": userMobile,
    "brand_id": brandId,
    "brand_name_ar": brandNameAr,
    "brand_name_en": brandNameEn,
    "model_id": modelId,
    "model_name_ar": modelNameAr,
    "model_name_en": modelNameEn,
    "part_id": partId,
    "part_name_ar": partNameAr,
    "partl_name_en": partlNameEn,
    "country_id": countryId,
    "country_name_ar": countryNameAr,
    "country_name_en": countryNameEn,
    "main_category_id": mainCategoryId,
    "main_category_name_ar": mainCategoryNameAr,
    "main_category_name_en": mainCategoryNameEn,
    "year_id": yearId,
    "year": year,
    "picpath": picpath,
  };
}
