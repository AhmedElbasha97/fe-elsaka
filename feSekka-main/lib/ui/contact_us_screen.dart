import 'package:FeSekka/widgets/loader.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
// import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  String? phoneTxt;
  String? emailTxt;
  bool isLoading = true;

  getContacts() async {
    Response response =
        await Dio().get("https://fe-alsekkah.com/api/settings");
    phoneTxt = response.data['mobile'];
    emailTxt = response.data['email'];
    isLoading = false;
    setState(() {});
  }

  FocusNode _emailFocusNode = FocusNode();
  FocusNode _titlemessageFocusNode = FocusNode();
  FocusNode _contentFocusNode = FocusNode();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _titlemessageController = new TextEditingController();
  TextEditingController _contentController = new TextEditingController();

  void unFocusNodes() {
    _emailFocusNode.unfocus();
    _titlemessageFocusNode.unfocus();
    _contentFocusNode.unfocus();
  }

  Future<void> _makePhoneCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text("${AppLocalizations.of(context)!.translate('callUs')}",
            style: TextStyle(color: Colors.black)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Loader()
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20)),
                  Text(
                    "اتصل بنا على",
                    style: TextStyle(color: Colors.green),
                  ),
                  InkWell(
                    onTap: () => _makePhoneCall('tel: $phoneTxt'),
                    child: Text(
                      "$phoneTxt",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    "او راسلنا على",
                    style: TextStyle(color: Colors.green),
                  ),
                  Text(
                    "$emailTxt",
                    style: TextStyle(color: Colors.green),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 10),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      focusNode: _emailFocusNode,
                      controller: _emailController,
                      textAlign:
                          Localizations.localeOf(context).languageCode == "en"
                              ? TextAlign.left
                              : TextAlign.right,
                      maxLength: 50,
                      maxLines: 2,
                      minLines: 1,
                      decoration: InputDecoration(
                          counterText: "",
                          contentPadding: EdgeInsets.only(
                            top: 20,
                            bottom: 1,
                            right: 20,
                            left: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          hintText: "email",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      focusNode: _titlemessageFocusNode,
                      controller: _titlemessageController,
                      textAlign:
                          Localizations.localeOf(context).languageCode == "en"
                              ? TextAlign.left
                              : TextAlign.right,
                      maxLines: 2,
                      minLines: 1,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                            top: 20,
                            bottom: 1,
                            right: 20,
                            left: 20,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          hintText: "subject",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child: TextField(
                      focusNode: _contentFocusNode,
                      controller: _contentController,
                      textAlign:
                          Localizations.localeOf(context).languageCode == "en"
                              ? TextAlign.left
                              : TextAlign.right,
                      maxLines: 15,
                      minLines: 12,
                      decoration: InputDecoration(
                          counterText: "",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          hintText: "content",
                          hintStyle: TextStyle(color: Colors.black)),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        final Email email = Email(
                          body: '${_contentController.text}',
                          subject: '${_titlemessageController.text}',
                          recipients: ['$emailTxt'],
                          isHTML: false,
                        );
                        await FlutterEmailSender.send(email);
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.075,
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "send",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15)),
                ],
              ),
            ),
    );
  }
}
