// To parse this JSON data, do
//
//     final providerProduct = providerProductFromJson(jsonString);

import 'dart:convert';

ProviderProduct providerProductFromJson(String str) => ProviderProduct.fromJson(json.decode(str));

String providerProductToJson(ProviderProduct data) => json.encode(data.toJson());

class ProviderProduct {
    ProviderProduct({
        this.productsId,
        this.titlear,
        this.titleen,
        this.created,
        this.image,
    });

    String? productsId;
    String? titlear;
    String? titleen;
    DateTime? created;
    dynamic image;

    factory ProviderProduct.fromJson(Map<String, dynamic> json) => ProviderProduct(
        productsId: json["products_id"] == null ? null : json["products_id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        created: json["created"] == null ? null : DateTime.parse(json["created"]),
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "products_id": productsId == null ? null : productsId,
        "titlear": titlear == null ? null : titlear,
        "titleen": titleen == null ? null : titleen,
        "created": created == null ? null : "${created!.year.toString().padLeft(4, '0')}-${created!.month.toString().padLeft(2, '0')}-${created!.day.toString().padLeft(2, '0')}",
        "image": image,
    };
}
