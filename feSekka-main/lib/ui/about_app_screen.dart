import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutAppScreen extends StatefulWidget {
  @override
  _AboutAppScreenState createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {
  String? term = "";

  getTermTxt() async {
    Response response = await Dio().get("https://carserv.net/api/settings");
    term = response.data['about_app'];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTermTxt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF66a5b4),
          iconTheme: new IconThemeData(color: Colors.white),
          title: Text(
            "${AppLocalizations.of(context)!.translate('aboutApp')}",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
        ),
        body: Html(data: "$term"));
  }
}
