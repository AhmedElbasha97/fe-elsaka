class ProductModel {
  String? id;
  String? titleAr;
  String? titleEn;
  String? price;
  String? salePrice;
  String? video;
  List<dynamic>? images;
  String? detailsAr;
  String? detailsEn;
  int? quantity;
  ProviderModel? provider;
  String? shareurl;
  String? type;

  ProductModel(
      {this.id,
      this.quantity,
      this.titleAr,
      this.titleEn,
      this.price,
      this.images,
      this.video,
      this.salePrice,
      this.detailsAr,
      this.detailsEn,
      this.provider,
        this.shareurl,
        this.type
      });

  factory ProductModel.fromJson(Map<String, dynamic> parsedJson) {
    return ProductModel(
        id: parsedJson['id'],
        titleAr: parsedJson['title_ar'],
        titleEn: parsedJson['title_en'],
        images: parsedJson['photos'] == "" ? [] : parsedJson['photos'],
        price: parsedJson['price'],
        video: parsedJson['youtube1'].contains("http")
            ? parsedJson['youtube1']
            : "",
        shareurl: parsedJson["shareurl"],
        salePrice: parsedJson['sale'],
        detailsAr: parsedJson['details_ar'],
        detailsEn: parsedJson['details_en'],
        quantity: parsedJson['in_mycart'],
        type:parsedJson["type"],
        provider: ProviderModel.fromJson(parsedJson['provider'],


        )
        //subCategory: subCategoryList
        );
  }
}

class ProviderModel {
  ProviderModel({
    this.providerId,
    this.titleen,
    this.titlear,
    this.mobile,
    this.whatsapp,
  });

  String? providerId;
  String? titleen;
  String? titlear;
  String? mobile;
  String? whatsapp;

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        providerId: json["provider_id"] == null ? null : json["provider_id"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
      );

}
