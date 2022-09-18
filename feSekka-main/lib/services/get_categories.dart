// ignore_for_file: deprecated_member_use

import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/model/category.dart';
import 'package:FeSekka/model/main_model.dart';

class GetCategories {
  final String url = "https://fe-alsekkah.com/api/";
  final String category = "category";
  final String main = "main/";
  final String location = "/location";
  final String countClick = "service/provider/clicks";

  Future<List<CategoryModel>> getCategory(String? id) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
    Datum? county;
    county = await getCountry();
    String link = "$url$category/$id";
    if (county != null) {
      link += "?country=${county.countryId}";
    }
    print(link);
    try {
      response = await Dio().get(link);
      List data = response.data;
      data.forEach((element) {
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
      List data = response.data;
      data.forEach((element) {
        categoryModelList.add(MainCategory.fromJson(element));
      });
    } on DioError catch (e) {
      print('error in category => ${e.response}');
    }
    return categoryModelList;
  }

  Future<List<CategoryModel>> searchCategory(String keyword) async {
    Response response;
    List<CategoryModel> categoryModelList = <CategoryModel>[];
    try {
      response = await Dio().get('$url$category?keyword=$keyword');
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
