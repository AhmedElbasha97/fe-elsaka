// ignore_for_file: deprecated_member_use

class CategoryModel {
  String? id;
  List<Sub>? sub;
  List<WrokHours>? wrokHours;
  String? titleAr;
  String? facebook;
  String? insgram;
  String? youtube;
  String? whatsapp;
  String? snapchat;
  String? titleEn;
  String? detailsAr;
  String? detailsEn;
  String? picpath;
  String? picpathEn;
  String? lat;
  String? long;
  String? mobile;
  List<String>? photos;
  String? rate;

  CategoryModel(
      {this.id,
      this.sub,
      this.wrokHours,
      this.titleAr,
      this.facebook,
      this.insgram,
      this.youtube,
        this.rate,

        this.whatsapp,
      this.snapchat,
      this.titleEn,
      this.detailsAr,
      this.detailsEn,
      this.picpath,
      this.picpathEn,
      this.lat,
      this.long,
      this.mobile,
      this.photos});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['sub'] != null) {
      sub = <Sub>[];
      json['sub'].forEach((v) {
        sub!.add(new Sub.fromJson(v));
      });
    }
    if (json['wrok_hours'] != null) {
      wrokHours = <WrokHours>[];
      json['wrok_hours'].forEach((v) {
        wrokHours!.add(new WrokHours.fromJson(v));
      });
    }
    photos = json["slider"] == null ? [] : json["slider"].cast<String>();
    titleAr = json['title_ar'];
    facebook = json['facebook'];
    insgram = json['insgram'];
    youtube = json['youtube'];
    whatsapp = json['whatsapp'];
    snapchat = json['snapchat'];
    titleEn = json['title_en'];
    detailsAr = json['details_ar'];
    detailsEn = json['details_en'];
    picpath = json['picpath'];
    picpathEn = json['picpath_en'];
    lat = json["lat"];
    long = json["long"];
    mobile = json["mobile"];
    rate = json["rate"];
  }
}

class Sub {
  String? id;
  String? titlear;
  String? titleen;
  String? picpath;

  Sub({this.id, this.titlear, this.titleen, this.picpath});

  Sub.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    titlear = json['titlear'];
    titleen = json['titleen'];
    picpath = json['picpath'];
  }
}

class WrokHours {
  String? id;
  String? titlear;
  String? titleen;
  String? hours;

  WrokHours({this.titlear, this.titleen, this.hours, this.id});

  WrokHours.fromJson(Map<String, dynamic> json) {
    id = json['work_hours_id'];
    titlear = json['titlear'];
    titleen = json['titleen'];
    hours = json['hours'];
  }
}
