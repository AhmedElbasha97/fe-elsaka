// ignore_for_file: deprecated_member_use

import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/splash_screen.dart';
import 'package:FeSekka/ui/men_or_women.dart';
import 'package:FeSekka/ui/providerScreens/OrdersScreen.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestUserScreen extends StatefulWidget {
  @override
  _TestUserScreenState createState() => _TestUserScreenState();
}

class _TestUserScreenState extends State<TestUserScreen> {
  @override
  void initState() {
    super.initState();
    getUserType();
  }

  getUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool checker = await ServiceProviderService().serviceCheckToken();
    if(checker){
      prefs.clear();
    }

    String? id = prefs.getString('provider_id');
    if (id == null || id == "") {
      String? countryStr = prefs.getString('savedCountry');
      if (countryStr == null) {
        pushPageReplacement(context, SplashScreen());
      } else {
        pushPageReplacement(context, MenOrWomen());

      }
    } else {

      bool locationEnbled = prefs.getBool('locationEnabled') ?? false;
      try {
        if (locationEnbled) {
          Position position =
          await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);
          ServiceProviderService().serviceProvidereditLocation(
              lat: "${position.latitude}", long: "${position.longitude}");
          ServiceProviderService().serviceProvidereditLocation();
        }
      } catch (e) {
        print("Location Error");
      } finally {
        pushPageReplacement(context, OrderScreen());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/icon/logo.png"),
              fit: BoxFit.scaleDown,
            ),
          )),
    ));
  }
}
