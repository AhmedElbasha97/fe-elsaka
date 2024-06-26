// ignore_for_file: deprecated_member_use

import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/model/product.dart';

class GetAllProducts {
  final String url = "https://carserv.net/api/";
  final String category = "products/page/";
  final String byCategory = "products/maincategory";

  Future getAllProducts(int page, String token) async {
    Response response;
    List<ProductModel> productModelList = <ProductModel>[];
    Datum? county;
    county = await getCountry();
    String link = "$url$category$page";
    print(link);
    if (county != null) {
      link += "?country=${county.countryId}";
    }
    try {
      if (token.isEmpty)
        response = await Dio().get(link);
      else
        response = await Dio().get(
          link,
          options: Options(headers: {"token": "$token"}),
        );
      List data = response.data['products'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in get products => ${e.response!.data}');
    }
    return productModelList;
  }

  Future getProductsbyCategory(int page, String? token, String? id,List<String> garage,List<String> zones,String isNew,String partId,String brandId,String modelId,String yearId) async {
    Response response;
    List<ProductModel> productModelList = <ProductModel>[];
    Datum? county;
    county = await getCountry();
    String link = "$url$byCategory/$id/page/$page";

    if (county != null) {
      link += "?country=${county.countryId}";
    }
    try {
      print("hi url ${link}options options: Options(headers: ${"token:" "$token,""garage:""$garage,"
          "zones:""$zones,"
          "is_new:""$isNew,"
          "part_id:""$partId,"
          "brand_id:""$brandId,"
          "model_id:""$modelId,"
          "year_id:""$yearId"}),");
      if (token == null)
        response = await Dio().get(link,
          options: Options(headers: {"garage":garage,
            "zones":zones,
            "is_new":isNew,
            "part_id":partId,
            "brand_id":brandId,
            "model_id":modelId,
            "year_id":yearId}),
        );
      else
        print("bye url ${link}");
        response = await Dio().get(
          link,
          options: Options(headers: {"token": "$token","garage":garage,
            "zones":zones,
            "is_new":isNew,
            "part_id":partId,
            "brand_id":brandId,
            "model_id":modelId,
            "year_id":yearId}),
        );

      print(link);
      List data = response.data['products'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in get products => ${e.response!.data}');
    }
    return productModelList;
  }
}
