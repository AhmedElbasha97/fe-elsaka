class Country {
  Country({
    this.status,
    this.data,
  });

  bool? status;
  List<Datum>? data;

  factory Country.fromJson(Map<String, dynamic> json) => Country(
        status: json["status"] == null ? null : json["status"],
        data: json["data"] == null
            ? null
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status == null ? null : status,
        "data": data == null
            ? null
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}

class Datum {
  Datum(
      {this.countryId,
      this.titlear,
      this.titleen,
      this.code,
      this.slug,
      this.currencyAr,
      this.currencyEn,
      this.image});

  String? countryId;
  String? titlear;
  String? titleen;
  String? code;
  String? slug;
  String? image;
  String? currencyAr;
  String? currencyEn;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        countryId: json["country_id"] == null ? null : json["country_id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        code: json["code"] == null ? null : json["code"],
        slug: json["slug"] == null ? null : json["slug"],
        currencyAr: json["currency_ar"] == null ? null : json["currency_ar"],
        currencyEn: json["currency_en"] == null ? null : json["currency_en"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "country_id": countryId == null ? null : countryId,
        "titlear": titlear == null ? null : titlear,
        "titleen": titleen == null ? null : titleen,
        "code": code == null ? null : code,
        "slug": slug == null ? null : slug,
        "image": image == null ? null : image,
        "currency_ar": currencyAr == null ? null : currencyAr,
        "currency_en": currencyEn == null ? null : currencyEn,
      };
}
