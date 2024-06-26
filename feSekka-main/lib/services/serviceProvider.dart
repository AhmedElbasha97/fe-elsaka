import 'dart:io';

import 'package:FeSekka/model/provider/authResult.dart';
import 'package:FeSekka/model/provider/product.dart';
import 'package:FeSekka/model/provider/profileData.dart';
import 'package:FeSekka/model/provider/providerOrders.dart';
import 'package:FeSekka/model/provider/sliderImg.dart';
import 'package:FeSekka/model/provider/subcategoryProvider.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/message_response_model.dart';

class ServiceProviderService {
  final String url = "https://carserv.net/api/";
  final String login = "service/provider/login";
  final String signup = "service/provider/signup";
  final String edit = "service/provider/profile";
  final String orders = "service/provider/orders";
  final String profile = "service/provider/profile/info";
  final String slider = "service/provider/slider/list";
  final String addNewSlider = "service/provider/slider/add";
  final String sliderdelete = "service/provider/slider/delete";
  final String products = "service/provider/products/list";
  final String productDelete = "service/provider/products/delete";
  final String addNewProduct = "service/provider/products/add";
  final String addNewOrder = "orders/new";
  final String subcategory = "service/provider/subcategory/list";
  final String checkToken  = "service/provider/check/token";
  final String deleteSubCatgoryLink = "service/provider/subcategory/delete";
  final String addsubCatogoryLInk = "service/provider/subcategory/add";

  Future<bool?> serviceProviderlogin(String mobile, String password,String token) async {
    bool result = false;


    var data = {"mobile": mobile, "password": password,"token":"$token"};
    Response response = await Dio().post("$url$login", data: data);

    if (response.data["status"] == true || response.data["status"] == "true") {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("provider_id", response.data['data']['provider_id']);
      prefs.setString("name", response.data['data']['name']);
      prefs.setString("mobile", response.data['data']['mobile']);
      prefs.setString("token", token);
      result = true;
    }
    return result;


  }
  Future<bool> serviceCheckToken() async {
    bool result = false;

    FirebaseMessaging.instance.getToken().then((token) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var mobile = prefs.get("mobile");
      var token = prefs.get("token");
      var data = {"mobile": mobile,"token":"$token"};
      Response response = await Dio().post("$url$checkToken", data: data);
      if (response.data["status"] == true || response.data["status"] == "true") {
        result = true;
      }
      return result;
    });
    return result;

    }


  Future<Authresult?> serviceProvidersignup(
      {String? mobile,
      String? password,
      String? username,
      String? whatsApp,
      String? lat,
      String? long,
      String? country,
      File? img,String? token,  List<String?>? mainCats,String? garage,List<String>? zoneId}) async {
    Authresult? result;
    FirebaseMessaging.instance.getToken().then((token) async {
    var data = FormData.fromMap({
      "username": username,
      "mobile": mobile,
      "password": password,
      "whatsapp": whatsApp,
      "lat": lat,
      "long": long,
      "country_id": country,
      "image": img == null ? null : await MultipartFile.fromFile('${img.path}'),"token":"$token",
      "main_category_id":mainCats,
      "garage":garage,
      "zones":zoneId
    });
    Response response = await Dio().post("$url$signup", data: data);
    print(response.data);
    print(response.data['data'][0]['token']);
    print(token);
    if (response.data["status"] == true || response.data["status"] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("provider_id", response.data['data'][0]['provider_id']);
      prefs.setString("name", response.data['data'][0]['name']);
      prefs.setString("mobile", response.data['data'][0]['mobile']);
      prefs.setString("token", token??"");
    }
    result = Authresult.fromJson(response.data);
     });
    return result;

  }

  Future<Authresult> serviceProvideredit(
      {String? mobile,
      String? password,
      String? username,
      String? whatsApp,
      String? lat,
      String? long,
      String? country,
        List<String?>? mainCats,
        File? img,
        String? garage,
        List<String>? zoneId
      }) async {
    Authresult result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    var data = FormData.fromMap({
      "provider_id": id,
      "username": username,
      "mobile": mobile,
      "password": password,
      "whatsapp": whatsApp,
      "lat": lat,
      "long": long,
      "country_id": country,
      "image": img == null ? null : await MultipartFile.fromFile('${img.path}'),
      "main_category_id": mainCats,
      "garage":garage,
      "zones":zoneId
    });
    Response response = await Dio().post("$url$edit", data: data);
    print(response.data);

    if (response.data["status"] == true || response.data["status"] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("provider_id", response.data['data'][0]['provider_id']);
      prefs.setString("name", response.data['data'][0]['name']);
      prefs.setString("mobile", response.data['data'][0]['mobile']);
    }
    result = Authresult.fromJson(response.data);
    return result;
  }

  Future<Authresult> serviceProvidereditLocation({
    String? lat,
    String? long,
  }) async {
    Authresult result;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    var data = FormData.fromMap({
      "provider_id": id,
      "lat": lat,
      "long": long,
    });
    Response response = await Dio().post("$url$edit", data: data);
    print(response.data);
    if (response.data["status"] == true || response.data["status"] == true) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("name", response.data['data'][0]['name']);
      prefs.setString("mobile", response.data['data'][0]['mobile']);
    }
    result = Authresult.fromJson(response.data);
    return result;
  }

  Future<List<ProviderOrders>> getOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    List<ProviderOrders> ordersList = [];
    Response response = await Dio().post("$url$orders", data: {"user_id": id});
    var data = response.data["data"];
    data.forEach((element) {
      ordersList.add(ProviderOrders.fromJson(element));
    });
    return ordersList;
  }

  Future<ProfileData?> getProfileData() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    ProfileData? profiledata;
    print("$url$profile${"provider_id:"+ "$id"}");
    Response response =
        await Dio().post("$url$profile", data: {"provider_id": id});
    var data = response.data["data"];

    if (data.isNotEmpty) {
      profiledata = ProfileData.fromJson(data[0]);
    }
    return profiledata;
  }

  Future<List<SliderImage>> getSliderImgs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    List<SliderImage> slidersImg = [];
    Response response =
        await Dio().post("$url$slider", data: {"provider_id": id});
    var data = response.data["data"];
    data.forEach((element) {
      slidersImg.add(SliderImage.fromJson(element));
    });
    return slidersImg;
  }

  deleteSliderImgs(String? imgId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    await Dio().post("$url$sliderdelete",
        data: {"provider_id": id, "slider_id": imgId});
  }

  addSliderImgs(File img) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    var data = FormData.fromMap({
      "provider_id": id,
      "image": img == null ? null : await MultipartFile.fromFile('${img.path}')
    });
    await Dio().post("$url$addNewSlider", data: data);
  }

  Future<List<ProviderProduct>> getProducts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    List<ProviderProduct> slidersImg = [];
    Response response =
        await Dio().post("$url$products", data: {"provider_id": id});
    var data = response.data["data"];
    data.forEach((element) {
      slidersImg.add(ProviderProduct.fromJson(element));
    });
    return slidersImg;
  }

  deleteProduct(String? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString("provider_id");
    await Dio().post("$url$productDelete",
        data: {"user_id": userid, "product_id": id});
  }

  addProduct(
      String details,
      String detailsEn,
      String price,
      String title,
      String titleEn,
      File? img,
      File? img2,
      File? img3,
      File? img4,
      String? subCat,
      List<String?>? mainCats,
      String videoLink,
      String type,
      File? video,
      List<String> garage,
      String? isNew,
      String? partId,
      String? brandId,
      List<String>? modelId,
      List<String>? yearId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    var data = FormData.fromMap({
      "provider_id": id,
      "image": img == null ? null : await MultipartFile.fromFile('${img.path}'),
      "image2":
          img2 == null ? null : await MultipartFile.fromFile('${img2.path}'),
      "image3":
          img3 == null ? null : await MultipartFile.fromFile('${img3.path}'),
      "image4":
          img4 == null ? null : await MultipartFile.fromFile('${img4.path}'),
      "video":
          video == null ? null : await MultipartFile.fromFile('${video.path}'),
      "titlear": title,
      "titleen": titleEn,
      "price": price,
      "detailsar": details,
      "detailsen": detailsEn,
      "subcategory_id": subCat,
      "main_category_id": mainCats,
      "youtube": videoLink,
      "type":type,
      "garage":garage,
      "is_new":isNew,
      "part_id":partId,
      "brand_id":brandId,
      "model_id":modelId,
      "year_id":yearId
    });
    Response res = await Dio().post("$url$addNewProduct", data: data);
    print(res.data);
  }
  Future<MessageResponseModel?>addRequest(
      String message,
      File? img,

      List<String?>? mainCats,
      String type,
      List<String> garage,
      String? isNew,
      String? partId,
      String? brandId,
      String? countryId,
      List<String>? modelId,
      List<String>? yearId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("id");
    var data = FormData.fromMap({
      "user_id": id,
      "image": img == null ? null : await MultipartFile.fromFile('${img.path}'),
      "country_id":countryId,
      "message": message,
      "main_category_id": mainCats,
      "type":type,
      "garage":garage,
      "is_new":isNew,
      "part_id":partId,
      "brand_id":brandId,
      "model_id":modelId,
      "year_id":yearId
    });
    Response res = await Dio().post("$url$addNewOrder", data: data);
    print(res.data);

    var datare = res.data;
    if(datare!=null){
      return MessageResponseModel.fromJson(datare);
    }
    return null;

  }

  Future<List<SubCategory>> getSubcatogies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    List<SubCategory> list = [];
    Response response =
        await Dio().post("$url$subcategory", data: {"provider_id": id});
    var data = response.data["data"];
    data.forEach((element) {
      list.add(SubCategory.fromJson(element));
    });
    return list;
  }

  deletesubCatogry(String? id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString("provider_id");
    await Dio().post("$url$deleteSubCatgoryLink",
        data: {"provider_id": userid, "subcategory_id": id});
  }

  addSubCatogry(String title, String titleEn, File? img) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    var data = FormData.fromMap({
      "provider_id": id,
      "image": img == null ? null : await MultipartFile.fromFile('${img.path}'),
      "titlear": title,
      "titleen": titleEn,
    });
    print("$url$addsubCatogoryLInk");
    print("titlear: $title,");
    print("titleen: $titleEn,");

    await Dio().post("$url$addsubCatogoryLInk", data: data);
  }
}
