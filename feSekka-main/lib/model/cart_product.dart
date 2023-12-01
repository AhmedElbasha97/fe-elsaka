class CartProductModel {
  String? id;
  String? titleAr;
  String? titleEn;
  String? price;
  String? quantity;
  int? quantityInCart;
  String? salePrice;
  String? image;
  String? categoryAr;
  String? categoryEn;
  List<String>? photos;
  String? shareurl;
  CartProductModel(
      {this.id,
      this.titleAr,
      this.titleEn,
      this.quantityInCart,
      this.price,
      this.image,
      this.salePrice,
      this.categoryAr,
      this.categoryEn,
      this.quantity,
        this.shareurl,
      this.photos});

  factory CartProductModel.fromJson(Map<String, dynamic> parsedJson) {
    return CartProductModel(
      id: parsedJson['product_id'],
      titleAr: parsedJson['titlear'],
      titleEn: parsedJson['titleen'],
      image: parsedJson['image'],
      price: parsedJson['price'],
      salePrice: parsedJson['sale'],
      shareurl: parsedJson["shareurl"],
      categoryAr: parsedJson['categoryar'],
      categoryEn: parsedJson['categoryen'],
      quantity: parsedJson['quantity'],
      quantityInCart: parsedJson['in_mycart'],
      photos: parsedJson["photos"] == null
          ? null
          : List<String>.from(parsedJson["photos"].map((x) => x)),
    );
  }
}
