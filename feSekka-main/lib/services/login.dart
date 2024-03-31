import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ui/men_or_women.dart';

class LoginService{
  final String url = "https://carserv.net/api/";
  final String loginEndPoint="login";

  Future loginService({String? phone, String? password,required BuildContext context}) async{
    Response response;
    String result='';
    FirebaseMessaging.instance.getToken().then((token) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      response = await Dio().post("$url$loginEndPoint",data: {"mobile":"$phone","password":"$password","token":"$token"});
      if(response.data['status'] == true) {
        print(response.data);
        await prefs.setString("id", response.data['data'][0]['id']);
        await prefs.setString("name", response.data['data'][0]['name']);
        await prefs.setString("phone", response.data['data'][0]['mobile']);
        await prefs.setString("email", response.data['data'][0]['email']);
        await prefs.setString("address", response.data['data'][0]['address']);
        await prefs.setString("gender", response.data['data'][0]['gender']);
        await prefs.setString("birthdayDate", response.data['data'][0]['birth_date']);
        await prefs.setString("token", response.data['data'][0]['token']);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => MenOrWomen(),
        ));
        result =  'success';
      }
      else{
        result =  response.data['message'];
      }

    }
    on DioError catch(e){
      print('error in LoginService => ${e.response}');
      return e.response;
    }
  });
    return result;
  }

}