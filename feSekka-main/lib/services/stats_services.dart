import 'package:dio/dio.dart';

class StatService{
  final String url = "https://carserv.net/api/";
  final String mobileEndPoint="service/provider/clicks/mobile";
  final String whatsAppEndPoint="service/provider/clicks/whatsapp";

  Future mobileStatService({required String providerId}) async{
    Response response;

    try{
      response = await Dio().post("$url$mobileEndPoint",data: {"provider_id":"$providerId"});
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
  Future whatsAppStatService({required String providerId}) async{
    Response response;

    try{
      response = await Dio().post("$url$whatsAppEndPoint",data: {"provider_id":"$providerId"});
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

}