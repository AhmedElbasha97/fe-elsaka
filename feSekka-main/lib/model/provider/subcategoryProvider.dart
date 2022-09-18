class SubCategory {
  SubCategory({
    this.subcategoryId,
    this.titlear,
    this.titleen,
    this.created,
    this.image,
  });

  String? subcategoryId;
  String? titlear;
  String? titleen;
  String? created;
  String? image;

  factory SubCategory.fromJson(Map<String, dynamic> json) => SubCategory(
        subcategoryId:
            json["subcategory_id"] == null ? null : json["subcategory_id"],
        titlear: json["titlear"] == null ? null : json["titlear"],
        titleen: json["titleen"] == null ? null : json["titleen"],
        created: json["created"] == null ? null : json["created"],
        image: json["image"],
      );
}
