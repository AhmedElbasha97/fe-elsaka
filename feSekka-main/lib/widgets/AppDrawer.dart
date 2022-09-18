// ignore_for_file: must_be_immutable, unused_local_variable

import 'package:FeSekka/I10n/AppLanguage.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/splash_screen.dart';
import 'package:FeSekka/ui/about_app_screen.dart';
import 'package:FeSekka/ui/contact_us_screen.dart';
import 'package:FeSekka/ui/edit_profile_screen.dart';
import 'package:FeSekka/ui/logIn_screen.dart';
import 'package:FeSekka/ui/myProducts_screen.dart';
import 'package:FeSekka/ui/providerScreens/logIn_screen.dart';
import 'package:FeSekka/ui/signUp_screen.dart';
import 'package:FeSekka/ui/supportChat.dart';
import 'package:FeSekka/ui/terms_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawer extends StatefulWidget {
  String? token, name;

  AppDrawer(this.token, this.name);
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String? facebookUrl = "";
  String? twitterUrl = "";
  String? youtubeUrl = "";
  String? whatsappUrl = "";
  String? instagramUrl = "";

  @override
  void initState() {
    super.initState();
    getSocialMediaLinks();
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.name = prefs.getString('name') ??
        "${AppLocalizations.of(context)!.translate('newUser')}";
    widget.token = prefs.getString('token') ?? "";
    return prefs;
  }

  getSocialMediaLinks() async {
    Response response = await Dio().get("https://fe-alsekkah.com/api/settings");
    facebookUrl = response.data['facebook'];
    twitterUrl = response.data['twitter'];
    youtubeUrl = response.data['youtube'];
    whatsappUrl = response.data['whatsapp'];
    instagramUrl = response.data['instagram'];
  }

  Widget changeLangPopUp() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text('${AppLocalizations.of(context)!.translate('language')}'),
      message: new Text(
          '${AppLocalizations.of(context)!.translate('changeLanguage')}'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: new Text('English'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("en"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: new Text('عربى'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("ar"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text('رجوع'),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          SizedBox(
            height: 200,
            child: Container(
              child: Image.asset(
                "assets/icon/logo.png",
                scale: 3,
              ),
            ),
          ),
          Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          widget.token == null || widget.token!.isEmpty
              ? ListTile(
                  title: Text(
                    widget.token == null || widget.token!.isEmpty
                        ? "${AppLocalizations.of(context)!.translate('newUser')}"
                        : "$widget.name",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF66a5b4),
                        fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.person, color: Color(0xFF66a5b4)),
                  onTap: () {
                    if (widget.token!.isEmpty)
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SignUpScreen(),
                      ));
                  })
              : Container(),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          widget.token == null || widget.token!.isEmpty
              ? ListTile(
                  title: Text(
                    "${AppLocalizations.of(context)!.translate('login')}",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF66a5b4),
                        fontWeight: FontWeight.bold),
                  ),
                  leading: Icon(Icons.person, color: Color(0xFF66a5b4)),
                  onTap: () {
                    // Update the state of the app
                    // ...
                    // Then close the drawer
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => LogInScreen(),
                    ));
                  },
                )
              : ListTile(
                  title: Text(
                      "${AppLocalizations.of(context)!.translate('editProfile')}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.bold)),
                  leading: Icon(Icons.edit, color: Color(0xFF66a5b4)),
                  onTap: () async {
                    bool? _ =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => EditProfileScreen(),
                    ));
                    getUserData();
                  },
                ),
          widget.token == null || widget.token!.isEmpty
              ? Container()
              : Divider(
                  height: 1,
                  thickness: 2,
                  endIndent: 30,
                  indent: 30,
                ),
          widget.token == null || widget.token!.isEmpty
              ? Container()
              : ListTile(
                  title: Text(
                      "${AppLocalizations.of(context)!.translate('myProducts')}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.bold)),
                  leading: Icon(Icons.shopping_cart, color: Color(0xFF66a5b4)),
                  onTap: () async {
                    bool? done =
                        await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MyProductsScreen(),
                    ));
                    getUserData();
                  },
                ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.translate('home')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.home, color: Color(0xFF66a5b4)),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SplashScreen(),
              ));
            },
          ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text(
                "${AppLocalizations.of(context)!.translate('chatSupport')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.support, color: Color(0xFF66a5b4)),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => SupportChatPage(),
              ));
            },
          ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text(
                "${AppLocalizations.of(context)!.translate('serviceProviders')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.people_alt, color: Color(0xFF66a5b4)),
            onTap: () {
              _showAlertDialog();
            },
          ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text(
                "${AppLocalizations.of(context)!.translate('changeLang')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.language, color: Color(0xFF66a5b4)),
            onTap: () => showCupertinoModalPopup(
                context: context,
                builder: (BuildContext context) => changeLangPopUp()),
          ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.translate('terms')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.description, color: Color(0xFF66a5b4)),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => TermsScreen(),
            )),
          ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.translate('whoAreWe')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.category, color: Color(0xFF66a5b4)),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AboutAppScreen(),
            )),
          ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          widget.token == null || widget.token!.isEmpty
              ? Container()
              : ListTile(
                  title: Text(
                      "${AppLocalizations.of(context)!.translate('signOut')}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.bold)),
                  leading: Icon(Icons.exit_to_app, color: Color(0xFF66a5b4)),
                  onTap: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SplashScreen(),
                    ));
                  },
                ),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.translate('callUs')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.phone, color: Color(0xFF66a5b4)),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ContactUsScreen(),
              ));
            },
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
              InkWell(
                onTap: () => launchURL("$facebookUrl"),
                child: Image.asset(
                  "assets/icon/facebook.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$instagramUrl"),
                child: Image.asset(
                  "assets/icon/instagram.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$twitterUrl"),
                child: Image.asset(
                  "assets/icon/twitter.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$whatsappUrl"),
                child: Image.asset(
                  "assets/icon/whatsapp.png",
                  scale: 1.5,
                ),
              ),
              InkWell(
                onTap: () => launchURL("$youtubeUrl"),
                child: Image.asset(
                  "assets/icon/youtube.png",
                  scale: 1.5,
                ),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 1)),
            ],
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 25)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "${AppLocalizations.of(context)!.translate('policy1')}",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text("${AppLocalizations.of(context)!.translate('policy2')}",
                    style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () => launchURL("https://www.syncqatar.com/"),
                  child: Text(
                    "سينك",
                    style: TextStyle(color: Colors.blue, fontSize: 16),
                  ),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
        ],
      ),
    );
  }

  Future<Future<bool?>> _showAlertDialog() async {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              content:
                  Text(AppLocalizations.of(context)!.translate('providerAlert')!),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.close),
                            Text(
                                AppLocalizations.of(context)!.translate('back')!),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Expanded(
                      child: MaterialButton(
                        color: Color(0xFF90caf9),
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.check),
                            Text(AppLocalizations.of(context)!
                                .translate('agree')!),
                          ],
                        ),
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.clear();
                          pushPageReplacement(context, SplashScreen());
                          pushPage(context, LoginProviderScreen());
                        },
                      ),
                    )
                  ],
                ),
              ],
            ));
  }
}
