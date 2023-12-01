import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationService{
  final String url = "https://carserv.net/api/";
  final String registrationEndPoint="register";

  Future registrationService({String? name, String? email, String? phone,String? password,String? gender, String? address, String? birthdayDate,double? lat,double? long}) async{
    FirebaseMessaging.instance.getToken().then((token) async {




    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "name":"$name",
      "mobile":"$phone",
      "email":"$email",
      "password":"$password",
      "address":"$address",
      "gender":"$gender",
      "birth_date":"$birthdayDate",
      "lat":"$lat",
      "long":"$long",
      "token":"$token"
    });
    try{
       response = await Dio().post("$url$registrationEndPoint",data: formData);
       if(response.data['status'] == true){
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
      print('error in RegistrationService => ${e.response}');
      return e.response;
    }
  });
  }
}