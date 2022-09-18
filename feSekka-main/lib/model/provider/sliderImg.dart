// To parse this JSON data, do
//
//     final sliderImage = sliderImageFromJson(jsonString);

import 'dart:convert';

SliderImage sliderImageFromJson(String str) =>
    SliderImage.fromJson(json.decode(str));

String sliderImageToJson(SliderImage data) => json.encode(data.toJson());

class SliderImage {
  SliderImage({
    this.sliderId,
    this.title,
    this.link,
    this.created,
    this.image,
  });

  String? sliderId;
  String? title;
  String? link;
  String? created;
  String? image;

  factory SliderImage.fromJson(Map<String, dynamic> json) => SliderImage(
        sliderId: json["slider_id"] == null ? null : json["slider_id"],
        title: json["title"] == null ? null : json["title"],
        link: json["link"] == null ? null : json["link"],
        created: json["created"] == null ? null : json["created"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "slider_id": sliderId == null ? null : sliderId,
        "title": title == null ? null : title,
        "link": link == null ? null : link,
        "created": created == null ? null : created,
        "image": image,
      };
}
