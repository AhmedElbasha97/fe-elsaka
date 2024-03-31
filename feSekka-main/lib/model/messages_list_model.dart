import 'dart:convert';

List<MessageListModel> messageListModelFromJson(String str) => List<MessageListModel>.from(json.decode(str).map((x) => MessageListModel.fromJson(x)));

String messageListModelToJson(List<MessageListModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class MessageListModel {
  String? messageId;
  String? orderId;
  String? message;
  String? created;
  String? providerId;
  String? providerNameAr;
  String? providerNameEn;
  String? whatsapp;
  String? mobile;

  MessageListModel({
    this.messageId,
    this.orderId,
    this.message,
    this.created,
    this.providerId,
    this.providerNameAr,
    this.providerNameEn,
    this.whatsapp,
    this.mobile,
  });

  factory MessageListModel.fromJson(Map<String, dynamic> json) => MessageListModel(
    messageId: json["message_id"],
    orderId: json["order_id"],
    message: json["message"],
    created: json["created"],
    providerId: json["provider_id"],
    providerNameAr: json["provider_name_ar"],
    providerNameEn: json["provider_name_en"],
    whatsapp: json["whatsapp"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "message_id": messageId,
    "order_id": orderId,
    "message": message,
    "created": created,
    "provider_id": providerId,
    "provider_name_ar": providerNameAr,
    "provider_name_en": providerNameEn,
    "whatsapp": whatsapp,
    "mobile": mobile,
  };
}