// ignore_for_file: deprecated_member_use

import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/model/category.dart';
import 'package:FeSekka/model/main_model.dart';

class GetCategories {
  final String url = "https://carserv.net/api/";


  final String category = "category";
  final String main = "main/";
  final String location = "/location";
  final String countClick = "service/provider/clicks";

  Future<List<CategoryModel>> getCategory(String? id,List<String> garage,List<String> zones, ) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
    Datum? county;
    county = await getCountry();
    String link = "$url$category/$id";
    if (county != null) {
      link += "?country=${county.countryId}";
    }
    print(link);
    print( 'options: Options(headers: {"garage:""$garage,"zones:""$zones"}),');
    try {
      response = await Dio().get(link,
          options: Options(headers: {"garage":garage,
            "zones":zones}),
      );
      List data = response.data;
      data.forEach((element) {
        print(element);
        categoryModelList.add(CategoryModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<MainCategory>> getMainCategory() async {
    Response response;
    List<MainCategory> categoryModelList = <MainCategory>[];
    try {
      response = await Dio().get('$url$main$category');
      print('$url$main$category');
      List data = response.data;
      data.forEach((element) {
        print(element);
        categoryModelList.add(MainCategory.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<CategoryModel>> searchCategory(String keyword,List<String> garage,List<String> zones,String isNew,String partId,String brandId,String modelId,String yearId) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
    try {
      response = await Dio().get('$url$category?keyword=$keyword',
          options: Options(headers: {"garage":garage,
            "zones":zones,
            "is_new":isNew,
            "part_id":partId,
            "brand_id":brandId,
            "model_id":modelId,
            "year_id":yearId}),);
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(CategoryModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<CategoryModel>> getCategoryByLocation(
      double lat, double long, String? id) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
    try {
      response = await Dio().post('$url$category$location',
          data: {"lat": "$lat", "long": "$long", "main_category_id": "$id"});
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(CategoryModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  sendClickCount(String? id, String type) async {
    try {
      await Dio()
          .post('$url$countClick', data: {"provider_id": id, "type": type});
    } on DioError catch (e) {
      print('error in clicks => ${e.response}');
    }
  }
}
