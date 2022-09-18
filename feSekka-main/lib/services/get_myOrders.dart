// ignore_for_file: deprecated_member_use

import 'package:dio/dio.dart';
import 'package:FeSekka/model/orders.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GetMyOrders {
  final String url = "https://fe-alsekkah.com/api/";
  final String orders = "orders";
  final String confirmOrder = "confirm/order";

  Future<List<OrdersModel>> getMyOrders() async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    List<OrdersModel> ordersModelList = <OrdersModel>[];
    try {
      response = await Dio().post(
        "$url$orders",
        options: Options(headers: {"token": "$token"}),
      );
      print('***************************************');
      print(response.data);
      print('***************************************');
      List? data = response.data['data'];
      if (data != null && data.isNotEmpty) {
        ordersModelList.clear();
        data.forEach((element) {
          ordersModelList.add(OrdersModel.fromJson(element));
        });
        print(response.data['data']);
      }
    } on DioError catch (e) {
      print('error in GetMyOrders => ${e.response}');
    }
    return ordersModelList;
  }

  orderRecieved({String? id}) async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String userId = prefs.getString('id') ?? "";

    var body = {"checkout_id": id, "member_id": userId};
    try {
      response = await Dio().post(
        "$url$confirmOrder",
        data: body,
        options: Options(headers: {"token": "$token"}),
      );
      print('***************************************');
      print(response.data);
      print('***************************************');
    } on DioError catch (e) {
      print('error in GetMyOrders => ${e.response}');
    }
  }
}
