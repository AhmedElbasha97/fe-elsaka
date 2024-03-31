import 'package:FeSekka/model/car_category_mmodel.dart';
import 'package:FeSekka/model/car_part_model.dart';
import 'package:FeSekka/model/car_year_model.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/model/programRequest.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/car_brand_model.dart';
import '../model/courser_model.dart';
import '../model/zones_model.dart';

class AppInfoService {
  final String url = "https://carserv.net/api/";
  final String countries = "service/provider/countries";
  final String complement = "service/provider/complain";
  final String orderProgram = "service/provider/program/orders";
  final String orderStatus = "service/provider/program";
  final String deleteAccount = "service/provider/delete/account";
  final String getZonesURL = "zones";
  final String getCarBrandURL = "brands";
  final String getCarCategoryURL = "models/";
  final String getCarsPartTypeURL = "parts";
  final String secondSliderURL = "slider2";
  final String getCarsYearURL = "years";

  Future<List<ZonesModel>?> getZones() async {
    Response response;
    List<ZonesModel>? zones = [];
    try {
      response = await Dio().get("$url$getZonesURL");
      var data = response.data;
      if (data != null) {
        for(var zone in data){
          zones.add(ZonesModel.fromJson(zone));
        }
      }
    } on DioError catch (e) {
      print('error from getCountries => ${e.response}');
    }
    return zones;
  }
  Future<List<CarBrandModel>?> getCarsBrands() async {
    Response response;
    List<CarBrandModel>? carBrandS = [];
    try {
      response = await Dio().get("$url$getCarBrandURL");
      var data = response.data;
      if (data != null) {
        for(var carBrand in data){
          carBrandS.add(CarBrandModel.fromJson(carBrand));
        }
      }
    } on DioError catch (e) {
      print('error from getCountries => ${e.response}');
    }
    return carBrandS;
  }
  Future<List<CarCategoryModel>?> getCarsCategories(String carModel) async {
    Response response;
    List<CarCategoryModel>? carCategories = [];
    try {
      response = await Dio().get("$url$getCarCategoryURL$carModel");
      var data = response.data;
      if (data != null) {
        for(var carCategory in data){
          carCategories.add(CarCategoryModel.fromJson(carCategory));
        }
      }
    } on DioError catch (e) {
      print('error from getCountries => ${e.response}');
    }
    return carCategories;
  } Future<List<CarYearModel>?> getCarsYears() async {
    Response response;
    List<CarYearModel>? carYears = [];
    try {
      response = await Dio().get("$url$getCarsYearURL");
      var data = response.data;
      if (data != null) {
        for(var carYear in data){
          carYears.add(CarYearModel.fromJson(carYear));
        }
      }
    } on DioError catch (e) {
      print('error from getCountries => ${e.response}');
    }
    return carYears;
  }
  Future<List<CarPartModel>?> getCarsPartType() async {
    Response response;
    List<CarPartModel>? carParts = [];
    try {
      response = await Dio().get("$url$getCarsPartTypeURL");
      var data = response.data;
      if (data != null) {
        for(var carPart in data){
          carParts .add(CarPartModel.fromJson(carPart));
        }
      }
    } on DioError catch (e) {
      print('error from getCountries => ${e.response}');
    }
    return carParts;
  }
  Future<List<CourserModel>?> getSlider()  async {
    Response response;
    List<CourserModel>? sliderPhotos = [];
    try {
      response = await Dio().get("$url$secondSliderURL");
      var data = response.data;
      if (data != null) {
        for(var sliderPhoto in data){
          sliderPhotos .add(CourserModel.fromJson(sliderPhoto));
        }
      }
    } on DioError catch (e) {
      print('error from getCountries => ${e.response}');
    }
    return sliderPhotos;
  }

  Future<Country?> getCountries() async {
    Response response;
    Country? country;
    try {
      response = await Dio().get("$url$countries");
      var data = response.data;
      if (data != null) country = Country.fromJson(data);
    } on DioError catch (e) {
      print('error from getCountries => ${e.response}');
    }
    return country;
  }

  Future<Country?> sendComplement(
      {String? name,
      String? email,
      String? mobile,
      String? subject,
      String? message,
      String? id}) async {
    Country? country;
    var data = {
      "name": name,
      "email": email,
      "mobile": mobile,
      "subject": subject,
      "message": message,
      "provider_id": id
    };
    try {
      await Dio().post("$url$complement", data: data);
    } on DioError catch (e) {
      print('error from send complements => ${e.response}');
    }
    return country;
  }

  Future<RequestProgram?> getRequestStatus() async {
    Response response;
    RequestProgram? program;
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("provider_id");
      var body = {"provider_id": id};
      response = await Dio().post("$url$orderStatus", data: body);
      var data = response.data;
      if (data != null) program = RequestProgram.fromJson(data);
    } on DioError catch (e) {
      print('${e.response}');
    }
    return program;
  }
  Future deleteAccountForEver(String id) async {
    Response response;
    try{
      response = await Dio().post("$url$deleteAccount",data: {"provider_id":"$id",});
      if(response.data['status'] == true) {
        return 'success';
      }
      else{
        return response.data['message'];
      }

    }
    on DioError catch(e){
      print('error in LoginService => ${e.response}');
      return e.response;
    }
  }
  sendProgramOrder({String? country, String? name, String? mobile}) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? id = prefs.getString("provider_id");
      var body = {
        "provider_id": id,
        "name": name,
        "country_id": country,
        "mobile": mobile
      };
      await Dio().post("$url$orderStatus", data: body);
    } on DioError catch (e) {
      print('${e.response}');
    }
  }
}
