import 'dart:io';

import 'package:FeSekka/model/spareParts/carModel.dart';
import 'package:FeSekka/model/spareParts/carYear.dart';
import 'package:FeSekka/model/spareParts/cartType.dart';
import 'package:FeSekka/model/spareParts/partQuailty.dart';
import 'package:FeSekka/model/spareParts/partType.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderSparepartService {
  final String baseUrl = "https://fe-alsekkah.com/api/";
  final String order = "cars/parts/orders";
  final String types = "cars/types";
  final String models = "cars/models/";
  final String years = "cars/years";
  final String partQuailty = "cars/parts_quality";
  final String partType = "cars/parts_types";

  Future<List<CarType>> getTypes() async {
    Response response;
    List<CarType> types = [];
    try {
      response = await Dio().get("$baseUrl$types");
      var data = response.data;
      data.forEach((element) {
        types.add(CarType.fromJson(element));
      });
    } on DioError catch (e) {
      print('${e.response}');
    }
    return types;
  }

  Future<List<CarModel>> getModels(String id) async {
    Response response;
    List<CarModel> types = [];
    try {
      response = await Dio().get("$baseUrl$models$id");
      var data = response.data;
      data.forEach((element) {
        types.add(CarModel.fromJson(element));
      });
    } on DioError catch (e) {
      print('${e.response}');
    }
    return types;
  }

  Future<List<PartQuailty>> getPartQuailty() async {
    Response response;
    List<PartQuailty> types = [];
    try {
      response = await Dio().get("$baseUrl$partQuailty");
      var data = response.data;
      data.forEach((element) {
        types.add(PartQuailty.fromJson(element));
      });
    } on DioError catch (e) {
      print('${e.response}');
    }
    return types;
  }

  Future<List<CarYear>> getYears() async {
    Response response;
    List<CarYear> types = [];
    try {
      response = await Dio().get("$baseUrl$years");
      var data = response.data;
      data.forEach((element) {
        types.add(CarYear.fromJson(element));
      });
    } on DioError catch (e) {
      print('${e.response}');
    }
    return types;
  }

  Future<List<PartType>> getPartType() async {
    Response response;
    List<PartType> types = [];
    try {
      response = await Dio().get("$baseUrl$partType");
      var data = response.data;
      data.forEach((element) {
        types.add(PartType.fromJson(element));
      });
    } on DioError catch (e) {
      print('${e.response}');
    }
    return types;
  }

  orderPart(
      {String? name,
      String? details,
      String? carType,
      String? carModel,
      String? carYear,
      String? partType,
      String? partQuailty,
      File? img}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var data = FormData.fromMap({
      "name": name,
      "details": details,
      "member_id": token,
      "cars_types_id": carType,
      "cars_models_id": carModel,
      "cars_years_id": carYear,
      "cars_parts_quality_id": partQuailty,
      "cars_parts_types": partType,
      "image": img == null ? null : await MultipartFile.fromFile('${img.path}')
    });
    try {
      await Dio().post("$baseUrl$order", data: data);
    } on DioError catch (e) {
      print('${e.response}');
    }
  }
}
