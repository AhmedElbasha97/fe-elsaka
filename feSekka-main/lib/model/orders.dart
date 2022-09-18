class OrdersModel {
  OrdersModel({
    this.id,
    this.categoryTitleAr,
    this.categoryTitleEn,
    this.imageCategory,
    this.total,
    this.products,
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
  String? address;
  String? status;
  String? no;
  String? created;

  factory OrdersModel.fromJson(Map<String, dynamic> json) => OrdersModel(
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
        address: json["address"] == null ? null : json["address"],
        status: json["status"] == null ? null : json["status"],
        no: json["no"] == null ? null : json["no"],
        created: json["created"] == null ? null : json["created"],
      );
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
}
