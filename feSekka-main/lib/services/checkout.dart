// ignore_for_file: missing_return

import 'package:dio/dio.dart';
import 'package:FeSekka/model/cerditData.dart';

class Checkout {
  final String url = "https://fe-alsekkah.com/api/";
  final String checkoutEndPoint = "checkout";
  final String creditData = "credit";

  checkout(
      {String? token,
      String? name,
      String? mobile,
      String? email,
      String? address,
      String? birthDate,
      String? streetNumber,
      String? lat,
      String? long,
      String? buildingNumber,
      String? discretNumber,
      String? selectedShift,
      String? paymentType,
      String? creditId,
      String? notes,
      int? totalPrice,
      int? isSale
      }) async {
    Response response;
    try {
      response = await Dio().post("$url$checkoutEndPoint",
          data: {
            "name": "$name",
            "mobile": "$mobile",
            "email": "$email",
            "gender": "male",
            "address": "$address",
            "birth_date": "$birthDate",
            "total": totalPrice,
            "is_sale": isSale,
            "zone_no": "$discretNumber",
            "street_no": "$streetNumber",
            "building_no": "$buildingNumber",
            "lat": "$lat",
            "long": "$long",
            "work_hours_id": "$selectedShift",
            "payment":"$paymentType",
            "credit_number":"$creditId",
            "notes":"$notes"
          },
          options: Options(headers: {"token": "$token"}));
      print(response.data);
    } on DioError catch (e) {
      print('error in checkout => ${e.response!.data}');
    }
  }

  Future<CreditData?> getCreditData(
      {String? token, String? id, String? categoryId}) async {
    Response response;
    CreditData crData;
    try {
      response = await Dio().post("$url$creditData",
          data: {"member_id": "$id", "category_id": "$categoryId"},
          options: Options(headers: {"token": "$token"}));
      crData = CreditData.fromJson(response.data);
      print(response.data);
      return crData;
    } on DioError catch (e) {
      print('error in checkout => ${e.response!.data}');
    }
    return null;
  }
}
