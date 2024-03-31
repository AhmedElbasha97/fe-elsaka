import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/provider/authResult.dart';
import '../ui/men_or_women.dart';

class RegistrationService{
  final String url = "https://carserv.net/api/";
  final String registrationEndPoint="register";

  Future<Authresult?> registrationService({String? name, String? email, String? phone,String? password,String? gender, String? address, String? birthdayDate,double? lat,double? long,required BuildContext context}) async{
    Authresult? result;
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
       if(response.data["status"] == true || response.data["status"] == true){
         print("hiiiiiiiiiidata");
         print(response.data);
         print(response.data['data'][0]['token']);
         print(token);
        await prefs.setString("id", response.data['data'][0]['id']);
         await  prefs.setString("name", response.data['data'][0]['name']);
         await prefs.setString("phone", response.data['data'][0]['mobile']);
         await prefs.setString("email", response.data['data'][0]['email']);
         await prefs.setString("address", response.data['data'][0]['address']);
         await prefs.setString("gender", response.data['data'][0]['gender']);
         await prefs.setString("birthdayDate", response.data['data'][0]['birth_date']);
         await prefs.setString("token", response.data['data'][0]['token']);
         result = Authresult.fromJson(response.data);
         print(result?.status);

         Navigator.of(context).pushReplacement(MaterialPageRoute(
           builder: (context) => MenOrWomen(),
         ));return result;
       }
       else{
         result = Authresult.fromJson(response.data);


       }
    }
    on DioError catch(e){

      print('error in RegistrationService => ${e.response}');
      return e.response;
    }
  });
    return result;
  }
}