// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:FeSekka/model/cart_product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartServices {
  final String url = "https://fe-alsekkah.com/api/";
  final String viewCartEndpoint = "mycart";
  final String addToCartEndpoint = "cart";
  final String removeFromCartEndpoint = "deletecart";
  final String decreaseFromCartEnPoint = "updatecart";
  static int? totalPrice;
  static int? totalQuantity;

  Future<List<CartProductModel>> viewCart(bool inCartSelected) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    List<CartProductModel> cartProductModelList = <CartProductModel>[];
    try {
      response = await Dio().post("$url$viewCartEndpoint", options: Options(headers: {"token": "$token"}));
      List? data = response.data['data'];
      totalPrice = response.data['total'];
      totalQuantity = response.data['total_quantity'];
      if(data != null)
      data.forEach((element) {
        cartProductModelList.add(CartProductModel.fromJson(element));
      });

    } on DioError catch (e) {
      print('error from viewcart => ${e.response}');
    }
    return cartProductModelList;
  }

  addToCart(var productId) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      response = await Dio()
          .post('$url$addToCartEndpoint', data: {"product_id": "$productId", "quantity": "1"}, options: Options(headers: {"token": "$token"}));
      print(response);
    } on DioError catch (e) {
      print('error from addToCart => ${e.response}');
    }
  }

  decreaseFromCart(var productId, int? quantity) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      response = await Dio().post('$url$decreaseFromCartEnPoint',
          data: {"product_id": "$productId", "quantity": "$quantity"}, options: Options(headers: {"token": "$token"}));
      print(response.data);
    } on DioError catch (e) {
      print('error from removeFromCart => ${e.response}');
    }
  }

  removeFromCart(var productId) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    try {
      response = await Dio().post('$url$removeFromCartEndpoint', data: {"product_id": "$productId"}, options: Options(headers: {"token": "$token"}));
      print(response.data);
    } on DioError catch (e) {
      print('error from removeFromCart => ${e.response}');
    }
  }

}
