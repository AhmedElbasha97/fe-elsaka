class Authresult {
  Authresult({
    this.status,
    this.message,
  });

  bool? status;
  String? message;

  factory Authresult.fromJson(Map<String, dynamic> json) => Authresult(
        status: json["status"] == null ? null : json["status"],
        message: json["message"] == null ? null : json["message"],
      );
}
