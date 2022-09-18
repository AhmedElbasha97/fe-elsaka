import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/model/programRequest.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppInfoService {
  final String url = "https://fe-alsekkah.com/api/";
  final String countries = "service/provider/countries";
  final String complement = "service/provider/complain";
  final String orderProgram = "service/provider/program/orders";
  final String orderStatus = "service/provider/program";

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
