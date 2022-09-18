class RequestProgram {
  RequestProgram({
    this.title,
    this.youtube,
    this.details,
    this.replay,
  });

  String? title;
  String? youtube;
  String? details;
  dynamic replay;

  factory RequestProgram.fromJson(Map<String, dynamic> json) => RequestProgram(
        title: json["title"] == null ? null : json["title"],
        youtube: json["youtube"] == null ? null : json["youtube"],
        details: json["details"] == null ? null : json["details"],
        replay: json["replay"],
      );
}
