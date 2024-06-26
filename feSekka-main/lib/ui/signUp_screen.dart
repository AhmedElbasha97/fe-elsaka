// ignore_for_file: deprecated_member_use, must_be_immutable

import 'dart:async';

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:FeSekka/services/registration.dart';
import 'package:FeSekka/ui/men_or_women.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../model/provider/authResult.dart';
import 'map_screen.dart';

class SignUpScreen extends StatefulWidget {
  bool isCheck;

  SignUpScreen({this.isCheck = false});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController selectedPlaceController = TextEditingController();
  late Country data;
  bool isLoading = true;
  DateTime dateTime = DateTime.now();
  Datum? selectedCountry;
  bool nameError = false;
  bool emailError = false;
  bool phoneError = false;
  bool passwordError = false;
  bool dateError = false;
  // late PickResult selectedPlace;
  TextEditingController addressController = TextEditingController();
  Position? position;
  Future<void> getCountryName() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> address =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placeMark = address.first;
    String? country = placeMark.country;
    print(address.first);
    print(country);
    setState(() {
      for(var item in data.data!){
        if(item.titleen?.toLowerCase()==country?.toLowerCase()) {
          selectedCountry=item;
          print(selectedCountry);
        }

      }
    });
    // this will return country name
  }
  void _navigateAndDisplaySelection(BuildContext context) async {

    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen()),
    );
    List<Placemark> i =
    await placemarkFromCoordinates(result.latitude, result.longitude);
    Placemark placeMark = i.first;
    final address="${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}";
    addressController.text = "${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}";
    setState(() {});
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(address)));
  }
  validate(BuildContext context) async {
    if (nameController.text.isEmpty)
      nameError = true;
    else
      nameError = false;
    if (emailController.text.isEmpty)
      emailError = true;
    else
      emailError = false;

    if (phoneController.text.isEmpty)
      phoneError = true;
    else
      phoneError = false;
    if (passwordController.text.isEmpty)
      passwordError = true;
    else
      passwordError = false;

    setState(() {});
    if (!nameError &&
        !emailError &&
        !phoneError &&
        !passwordError &&
        !dateError) {
      FirebaseMessaging.instance.getToken().then((token) async {
        Authresult?  response = await RegistrationService().registrationService(
          name: nameController.text,
          email: emailController.text,
          phone: selectedCountry == null
              ? "${selectedCountry!.code}${phoneController.text}"
              : phoneController.text,
          password: passwordController.text,
          gender: "male",
          address: addressController.text,
          birthdayDate: "${dateTime.day}/${dateTime.month}/${dateTime.year}",
          lat: position == null ? 0.0 : position!.latitude,
          long: position == null ? 0.0 : position!.longitude, context: context,
        ) ;
        print("hi to screen");
        print(response?.status);
        if (response != null && (response.status??false) ) {

        }
        else {

          final snackBar = SnackBar(content: Text('${response?.message}'));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      });


    }
  }
  authAction(Authresult?  response){

  }
  getData() async {
    // title = await AppDataService().getCvTitle();
    data = (await AppInfoService().getCountries())!;
    if (data.data!.isNotEmpty) {
      selectedCountry = data.data!.first;
    }
    isLoading = false;
    getCountryName();
    setState(() {});
  }
  @override
  initState()  {
    super.initState();

    getData();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF66a5b4),
        title: Text(
          "${AppLocalizations.of(context)!.translate('signUp')}",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Builder(
        builder: (context) {
          return isLoading?Loader():SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20)),
                Image.asset(
                  "assets/icon/logo3.png",
                  scale: 3,
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20)),
                Container(
                  width: MediaQuery.of(context).size.width,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF66a5b4))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF66a5b4))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText:
                            "${AppLocalizations.of(context)!.translate('name')}"),
                  ),
                ),
                nameError
                    ? Text(
                        "please enter your name",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: emailController,
                    textDirection: TextDirection.ltr,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF66a5b4))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF66a5b4))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText:
                            "${AppLocalizations.of(context)!.translate('email')}"),
                  ),
                ),
                emailError
                    ? Text(
                        "please enter your email",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Color(0xFF66a5b4))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Color(0xFF66a5b4))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.green)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('phoneNumber')}"),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    InkWell(
                      onTap: () {

                        showAdaptiveActionSheet(
                          context: context,
                          title: Text(
                            "${AppLocalizations.of(context)?.translate('country')}",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 12),
                          ),
                          actions: data.data!
                              .map<BottomSheetAction>(
                                  (Datum value) {
                                return BottomSheetAction(
                                    title: Padding(
                                      padding:
                                      const EdgeInsets.all(
                                          8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.network(value.image??"",height: 35,width: 35,),
                                              SizedBox(width: 10,),
                                              Text(
                                                "${Localizations.localeOf(context).languageCode == 'en' ? value.titleen : value.titlear}",
                                                textAlign:
                                                TextAlign.start,
                                                style: TextStyle(
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            "${value.code}",
                                            textAlign:
                                            TextAlign.start,
                                            style: TextStyle(
                                                fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onPressed: (build) {
                                      selectedCountry = value;
                                      setState(() {});
                                      Navigator.of(context)
                                          .pop();
                                    });
                              }).toList(),
                        );
                      },
                      child: Row(
                        children: [
                          Image.network(selectedCountry == null ? data.data!.first.image! : selectedCountry!.image!,height: 35,width: 35,),
                          SizedBox(width: 10,),
                          Text(
                              "${selectedCountry == null ? data.data!.first.code : selectedCountry!.code}"),
                        ],
                      ),
                    )
                  ],
                ),
                phoneError
                    ? Text(
                        "please enter your phone number",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 25,
                          vertical: 15,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF66a5b4))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Color(0xFF66a5b4))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            borderSide: BorderSide(color: Colors.green)),
                        hintText:
                            "${AppLocalizations.of(context)!.translate('password')}"),
                  ),
                ),
                passwordError
                    ? Text(
                        "please enter your password",
                        style: TextStyle(color: Colors.red),
                      )
                    : Container(),
                Padding(padding: EdgeInsets.only(top: 10)),
                Padding(padding: EdgeInsets.only(top: 10)),
                Padding(padding: EdgeInsets.only(top: 10)),

                InkWell(
                  onTap: () async {
                    _navigateAndDisplaySelection(context);
                  },
                  child: IgnorePointer(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: TextField(
                        controller: addressController,

                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Color(0xFF66a5b4))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Color(0xFF66a5b4))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.green)),
                            hintText: "your address to deliver our products to it",
                            hintStyle: TextStyle(fontSize: 16)),
                      ),
                    ),
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 25)),
                InkWell(
                  onTap: () {
                    validate(context);
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: Color(0xFF66a5b4),
                    ),
                    child: Text(
                      "${AppLocalizations.of(context)!.translate('login')}",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 20))
              ],
            ),
          );
        },
      ),
    );
  }
}
