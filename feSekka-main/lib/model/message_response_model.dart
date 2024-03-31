import 'dart:convert';

MessageResponseModel messageResponseModelFromJson(String str) => MessageResponseModel.fromJson(json.decode(str));

String messageResponseModelToJson(MessageResponseModel data) => json.encode(data.toJson());

class MessageResponseModel {
  bool? status;
  String? message;

  MessageResponseModel({
    this.status,
    this.message,
  });

  factory MessageResponseModel.fromJson(Map<String, dynamic> json) => MessageResponseModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };
}