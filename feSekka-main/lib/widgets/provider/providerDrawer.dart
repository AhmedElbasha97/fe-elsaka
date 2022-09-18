import 'package:FeSekka/I10n/AppLanguage.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/splash_screen.dart';
import 'package:FeSekka/ui/contact_us_screen.dart';
import 'package:FeSekka/ui/providerScreens/SliderPage.dart';

import 'package:FeSekka/ui/providerScreens/productsScreen.dart';
import 'package:FeSekka/ui/providerScreens/providerProfilescreen.dart';
import 'package:FeSekka/ui/providerScreens/subCatogoriesList.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProviderDrawer extends StatefulWidget {
  @override
  _ProviderDrawerState createState() => _ProviderDrawerState();
}

class _ProviderDrawerState extends State<ProviderDrawer> {
  String name = "";
  String token = "";
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
        children: [
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
          Padding(padding: EdgeInsets.symmetric(vertical: 10)),
          ListTile(
              title: Text(
                  "${AppLocalizations.of(context)!.translate('editProfile')}",
                  style: TextStyle(
                      fontSize: 18,
                      color: Color(0xFF66a5b4),
                      fontWeight: FontWeight.bold)),
              leading: Icon(Icons.edit, color: Color(0xFF66a5b4)),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProviderProfileScreen(),
                ));
              }),
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.translate('products')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.shopping_cart, color: Color(0xFF66a5b4)),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ProductsScreen(),
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
            title: Text("${AppLocalizations.of(context)!.translate('slider')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.photo, color: Color(0xFF66a5b4)),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SliderScreen(),
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
            title: Text("${AppLocalizations.of(context)!.translate('subCats')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.category, color: Color(0xFF66a5b4)),
            onTap: () async {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SubCatPage(),
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
          Divider(
            height: 1,
            thickness: 2,
            endIndent: 30,
            indent: 30,
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.translate('signOut')}",
                style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF66a5b4),
                    fontWeight: FontWeight.bold)),
            leading: Icon(Icons.exit_to_app, color: Color(0xFF66a5b4)),
            onTap: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.clear();
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SplashScreen(),
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
}
