// To parse this JSON data, do
//
//     final providerOrders = providerOrdersFromJson(jsonString);

import 'dart:convert';

List<ProviderOrders> providerOrdersFromJson(String str) =>
    List<ProviderOrders>.from(
        json.decode(str).map((x) => ProviderOrders.fromJson(x)));

String providerOrdersToJson(List<ProviderOrders> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProviderOrders {
  ProviderOrders({
    this.id,
    this.categoryTitleAr,
    this.categoryTitleEn,
    this.imageCategory,
    this.total,
    this.products,
    this.name,
    this.email,
    this.mobile,
    this.nationality,
    this.address,
    this.status,
    this.no,
    this.created,
  });

  String? id;
  String? categoryTitleAr;
  String? categoryTitleEn;
  String? imageCategory;
  String? total;
  List<Product>? products;
  String? name;
  String? email;
  String? mobile;
  String? nationality;
  String? address;
  String? status;
  String? no;
  String? created;

  factory ProviderOrders.fromJson(Map<String, dynamic> json) => ProviderOrders(
        id: json["id"] == null ? null : json["id"],
        categoryTitleAr: json["category_title_ar"] == null
            ? null
            : json["category_title_ar"],
        categoryTitleEn: json["category_title_en"] == null
            ? null
            : json["category_title_en"],
        imageCategory:
            json["image_category"] == null ? null : json["image_category"],
        total: json["total"] == null ? null : json["total"],
        products: json["products"] == null
            ? null
            : List<Product>.from(
                json["products"].map((x) => Product.fromJson(x))),
        name: json["name"] == null ? null : json["name"],
        email: json["email"] == null ? null : json["email"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        nationality: json["nationality"] == null ? null : json["nationality"],
        address: json["address"] == null ? null : json["address"],
        status: json["status"] == null ? null : json["status"],
        no: json["no"] == null ? null : json["no"],
        created: json["created"] == null ? null : json["created"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "category_title_ar": categoryTitleAr == null ? null : categoryTitleAr,
        "category_title_en": categoryTitleEn == null ? null : categoryTitleEn,
        "image_category": imageCategory == null ? null : imageCategory,
        "total": total == null ? null : total,
        "products": products == null
            ? null
            : List<dynamic>.from(products!.map((x) => x.toJson())),
        "name": name == null ? null : name,
        "email": email == null ? null : email,
        "mobile": mobile == null ? null : mobile,
        "nationality": nationality == null ? null : nationality,
        "address": address == null ? null : address,
        "status": status == null ? null : status,
        "no": no == null ? null : no,
        "created": created == null ? null : created,
      };
}

class Product {
  Product({
    this.id,
    this.price,
    this.titleAr,
    this.titleEn,
    this.image,
  });

  String? id;
  String? price;
  String? titleAr;
  String? titleEn;
  String? image;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] == null ? null : json["id"],
        price: json["price"] == null ? null : json["price"],
        titleAr: json["title_ar"] == null ? null : json["title_ar"],
        titleEn: json["title_en"] == null ? null : json["title_en"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "price": price == null ? null : price,
        "title_ar": titleAr == null ? null : titleAr,
        "title_en": titleEn == null ? null : titleEn,
        "image": image == null ? null : image,
      };
}
