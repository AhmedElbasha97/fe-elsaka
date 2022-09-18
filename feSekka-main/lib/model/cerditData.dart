class CreditData {
  CreditData({
    this.status,
    this.data,
  });

  bool? status;
  List<Datum>? data;

  factory CreditData.fromJson(Map<String, dynamic> json) => CreditData(
        status: json["status"],
        data: json["status"] == false
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );
}

class Datum {
  Datum({
    this.codes,
    this.active,
  });

  String? codes;
  String? active;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        codes: json["codes"],
        active: json["active"],
      );
}
