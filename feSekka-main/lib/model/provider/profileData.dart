class ProfileData {
  ProfileData({
    this.providerId,
    this.name,
    this.titlear,
    this.titleen,
    this.facebook,
    this.insgram,
    this.youtube,
    this.whatsapp,
    this.whatsappClicks,
    this.mobile,
    this.mobileClicks,
    this.lat,
    this.long,
    this.image,
    this.mainCategoryId,
    this.orders,
  });

  String? providerId;
  String? name;
  String? titlear;
  String? titleen;
  String? facebook;
  String? insgram;
  String? youtube;
  String? whatsapp;
  String? whatsappClicks;
  String? mobile;
  String? mobileClicks;
  String? lat;
  String? long;
  String? image;
  List<String>? mainCategoryId;
  int? orders;

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        providerId: json["provider_id"] == null ? null : json["provider_id"],
        name: json["name"] == null ? null : json["name"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        facebook: json["facebook"] == null ? null : json["facebook"],
        insgram: json["insgram"],
        youtube: json["youtube"] == null ? null : json["youtube"],
        whatsapp: json["whatsapp"] == null ? null : json["whatsapp"],
        whatsappClicks:
            json["whatsapp_clicks"] == null ? null : json["whatsapp_clicks"],
        mobile: json["mobile"] == null ? null : json["mobile"],
        mobileClicks:
            json["mobile_clicks"] == null ? null : json["mobile_clicks"],
        lat: json["lat"] == null ? null : json["lat"],
        long: json["long"] == null ? null : json["long"],
        image: json["image"],
        orders: json["orders"] == null ? null : json["orders"],
    mainCategoryId: json["main_category_id"] == null ? [] : List<String>.from(json["main_category_id"]?.map((x) => x)),

  );
}
