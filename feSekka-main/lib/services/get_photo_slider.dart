import 'package:dio/dio.dart';

class GetPhotoSlider{
  final String url = "https://carserv.net/api/";
  final String slider = "slider";
  
  getPhotoSlider() async{
    Response response;
    try{
      response = await Dio().get("$url$slider");
      return response.data['photes'];
    }
    on DioError catch(e){
      print('error in GetPhotoSlider: => ${e.response}');
    }
  }
  
}