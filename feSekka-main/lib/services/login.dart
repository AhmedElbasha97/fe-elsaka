import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService{
  final String url = "https://fe-alsekkah.com/api/";
  final String loginEndPoint="login";

  Future loginService({String? phone, String? password}) async{
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      response = await Dio().post("$url$loginEndPoint",data: {"mobile":"$phone","password":"$password"});
      if(response.data['status'] == true) {
        print(response.data);
        prefs.setString("id", response.data['data'][0]['id']);
        prefs.setString("name", response.data['data'][0]['name']);
        prefs.setString("phone", response.data['data'][0]['mobile']);
        prefs.setString("email", response.data['data'][0]['email']);
        prefs.setString("address", response.data['data'][0]['address']);
        prefs.setString("gender", response.data['data'][0]['gender']);
        prefs.setString("birthdayDate", response.data['data'][0]['birth_date']);
        prefs.setString("token", response.data['data'][0]['token']);
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

}