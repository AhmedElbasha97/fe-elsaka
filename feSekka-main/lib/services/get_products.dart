// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:FeSekka/model/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetProducts{
  final String url = "https://carserv.net/api/";
  final String category="products/category/";
  final String subCategory="products/subcategory/";
  static List? categoryPhotos;
  static String? offerDialogAr;
  static String? offerDialogEn;

  
  Future<List<ProductModel>> getProducts(String? categoryId, int page) async{
    Response response;
    List<ProductModel> productModelList = <ProductModel>[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") ?? "";
    print("$url$category$categoryId/page/$page");
    try {
      token.isEmpty
          ? response = await Dio().get("$url$category$categoryId/page/$page")
          : response = await Dio().get("$url$category$categoryId/page/$page", options: Options(headers: {"token": "$token"}));
      List data = response.data['products'];
      categoryPhotos = response.data['category_slider'];
      offerDialogAr = response.data['category_slider_details_ar'];
      offerDialogEn = response.data['category_slider_details_en'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });

    } on DioError catch(e){
      print('error in get products => ${e.response!.data}');
    }

    return productModelList;
  }

  Future<List<ProductModel>> getSubCategoryProducts(String? categoryId, int page) async{
    Response response;
    List<ProductModel> productModelList = <ProductModel>[];
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String token = preferences.getString("token") ?? "";

    try {
      token.isEmpty
          ? response = await Dio().get("$url$subCategory$categoryId/page/$page")
          : response = await Dio().get("$url$subCategory$categoryId/page/$page", options: Options(headers: {"token": "$token"}));
      List data = response.data['products'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });

    } on DioError catch(e){
      print('error in get products => ${e.response!.data}');
    }

    return productModelList;
  }

  
}