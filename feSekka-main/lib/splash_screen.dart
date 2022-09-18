import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:FeSekka/ui/men_or_women.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'I10n/AppLanguage.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Country? countriesData;
  Datum? selectedCountry;
  bool loading = true;

  getCountry() async {
    countriesData = await AppInfoService().getCountries();
    try {
      selectedCountry =
          countriesData!.data!.firstWhere((element) => element.titlear == "قطر");
      saveCountry(selectedCountry!);
    } catch (e) {}
    loading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCountry();
  }

  @override
  Widget build(BuildContext context) {
    var appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icon/logo.png"),
                    fit: BoxFit.scaleDown,
                  ),
                )),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: () {
                    appLanguage.changeLanguage(Locale("en"));
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MenOrWomen(),
                    ));
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: Color(0xFF66a5b4)),
                        color: Color(0xFF66a5b4)),
                    child: Text("English",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  )),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  appLanguage.changeLanguage(Locale("ar"));
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MenOrWomen(),
                  ));
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      border: Border.all(color: Color(0xFF66a5b4)),
                      color: Color(0xFF66a5b4)),
                  child: Text("عربي",
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            loading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                        onTap: () {
                          showAdaptiveActionSheet(
                            context: context,
                            title: Center(
                              child: Text(
                                "${AppLocalizations.of(context)!.translate('country')}",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            actions: countriesData!.data!
                                .map<BottomSheetAction>((Datum value) {
                              return BottomSheetAction(
                                  title: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 10, left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${Localizations.localeOf(context).languageCode == "en" ? value.titleen : value.titlear}',
                                          textAlign: TextAlign.start,
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: CachedNetworkImage(
                                              imageUrl: "${value.image}"),
                                        )
                                      ],
                                    ),
                                  ),
                                  onPressed: (_)  {
                                    selectedCountry = value;
                                    saveCountry(selectedCountry!);
                                    setState(() {});
                                    Navigator.of(context).pop();
                                  });
                            }).toList(),
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          height: 45,
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: Color(0xFF66a5b4)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  selectedCountry == null
                                      ? "${AppLocalizations.of(context)!.translate('selectCountry')}"
                                      : Localizations.localeOf(context)
                                                  .languageCode ==
                                              "en"
                                          ? "${selectedCountry!.titleen}"
                                          : "${selectedCountry!.titlear}",
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 20),
                                  textAlign: TextAlign.start,
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  child: CachedNetworkImage(
                                      imageUrl: selectedCountry == null
                                          ? ""
                                          : "${selectedCountry!.image}"),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
          ],
        ));
  }
}
