import 'package:FeSekka/model/provider_request_list_model.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/message_response_model.dart';
import '../model/messages_list_model.dart';
import '../model/user_request_list_model.dart';

class requestServices{
  final String url = "https://carserv.net/api/";
  final String providerUrl="orders/provider";
  final String userUrl="orders/user";
  final String sendingMessageUrl="orders/new/message";
  final String listMessageUrl="orders/messages/page/1";
  static List? categoryPhotos;
  static String? offerDialogAr;
  static String? offerDialogEn;
  Future<List<ProviderRequestListModel>> getProviderRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    List<ProviderRequestListModel> requestsModelList = [];
    Response response =
    await Dio().post("$url$providerUrl", data: {"provider_id": id});
    var data = response.data;
    data.forEach((element) {
      requestsModelList.add(ProviderRequestListModel.fromJson(element));
    });
    return requestsModelList;
  }
  Future<List<UserRequestListModel>> getUserRequests() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? "";
    List<UserRequestListModel> requestsModelList = [];
    Response response =
    await Dio().post("$url$userUrl", data: {"user_id": userId});
    print(response.data);
    var data = response.data;
    data.forEach((element) {
      requestsModelList.add(UserRequestListModel.fromJson(element));
    });
    return requestsModelList;
  }
  Future<List<MessageListModel>> getMessagesList(String orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString('id') ?? "";
    List<MessageListModel> messagesList = [];
    Response response =
    await Dio().post("$url$listMessageUrl", data: {"user_id": userId,"order_id":orderId});
    print(response.data);
    var data = response.data;
    data.forEach((element) {
      messagesList.add(MessageListModel.fromJson(element));
    });
    return messagesList;
  }
  Future<MessageResponseModel?>sendingMessageToClient(String orderId,String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? id = prefs.getString("provider_id");
    Response response =
    await Dio().post("$url$sendingMessageUrl", data: {"order_id": orderId,"provider_id":id,"message":message});
    var data = response.data;
    if(data!=null){
      return MessageResponseModel.fromJson(data);
    }
    return null;
  }
}


