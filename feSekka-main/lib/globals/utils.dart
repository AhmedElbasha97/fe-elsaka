import 'dart:convert';

import 'package:FeSekka/model/countries.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

Future<void> saveCountry(Datum data) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool result =
      await prefs.setString('savedCountry', jsonEncode(data.toJson()));
  print(result);
}

Future<Datum?> getCountry() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, dynamic>? countryMap;
  final String countryStr = prefs.getString('savedCountry')!;
  countryMap = jsonDecode(countryStr) as Map<String, dynamic>?;
  if (countryMap != null) {
    final Datum data = Datum.fromJson(countryMap);
    return data;
  }
  return null;
}

////////////////////////////////////////////////
/// Page Navigation pages
////////////////////////////////////////////////
void popPage(BuildContext context) {
  Navigator.of(context).pop();
}

void pushPage(BuildContext context, Widget widget) {
  Navigator.push(context, MaterialPageRoute(builder: (context) => widget));
}

void pushPageReplacement(BuildContext context, Widget widget) {
  Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => widget));
}
const Color kWhiteColor = Color(0xFFEEF0F2);
const Color kGrayColor = Color(0xFF9E9C9C);