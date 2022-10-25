import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/ui/men_or_women.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_screen.dart';


class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? token;
  String? userAddress;
  DateTime dateTime = DateTime.now();
  String? birthDate ="";
  late Country? data;
  Datum? selectedCountry;
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
      for(var item in data!.data!){
        if(item.titleen?.toLowerCase()==country?.toLowerCase()) {
          selectedCountry=item;
          print(selectedCountry);
        }

      }
    });
    // this will return country name
  }
  getData() async {
    // title = await AppDataService().getCvTitle();
    data = (await AppInfoService().getCountries())!;
    if (data!.data!.isNotEmpty) {
      selectedCountry = data!.data!.first;
    }

    getCountryName();
    isLoading = false;
    setState(() {});
  }

  // late PickResult selectedPlace;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = true;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    getData();
    Response response = await Dio().post("https://fe-alsekkah.com/api/info",
        options: Options(headers: {"token": "$token"}));

    nameController.text = response.data['data'][0]['name'];
    emailController.text = response.data['data'][0]['email'];
    mobileController.text = response.data['data'][0]['mobile'];
    birthDate = response.data['data'][0]['birth_date'];
    userAddress = response.data['data'][0]['address'];

    isLoading = false;
    setState(() {});

    print(response.data);
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
    userAddress= "${placeMark.street},${placeMark.subAdministrativeArea},${placeMark.subLocality},${placeMark.country}";
    setState(() {});
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(address)));
  }
  updateInfo() async {
    Response response;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      response = await Dio().post(
        "https://fe-alsekkah.com/api/editinfo",
        data: passwordController.text.isEmpty
            ? {
                "name": "${nameController.text}",
                "mobile": selectedCountry == null
                    ? "${selectedCountry!.code}${mobileController.text}"
                    : mobileController.text,
                "email": "${emailController.text}",
                "address": "$userAddress",
                "gender": "male",
                "birth_date": "$birthDate",
              }
            : {
                "name": "${nameController.text}",
                "mobile": selectedCountry == null
                    ? "${selectedCountry!.code}${mobileController.text}"
                    : mobileController.text,
                "email": "${emailController.text}",
                "password": "${passwordController.text}",
                "address": "$userAddress",
                "gender": "male",
                "birth_date": "$birthDate",
              },
        options: Options(headers: {"token": "$token"}),
      );
      print(response.data);

      prefs.setString("name", nameController.text);
      prefs.setString("phone", selectedCountry == null
          ? "${selectedCountry!.code}${mobileController.text}"
          : mobileController.text);
      prefs.setString("email", emailController.text);
      prefs.setString("address", userAddress!);
      prefs.setString("gender", "male");
      prefs.setString("birthdayDate", birthDate!);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => MenOrWomen(),
      ));
    } on DioError catch (e) {
      print('error in edit profile => ${e.response}');
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          "${AppLocalizations.of(context)!.translate('editProfile')}",
          style: TextStyle(color: Colors.blue),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.blue,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ?  Loader()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: Image.asset(
                      "assets/icon/logo.png",
                      scale: 7,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 20)),
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFFF3F3F3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('name')}"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: TextField(
                              controller: mobileController,
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
                                actions: data!.data!
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
                                Image.network(selectedCountry == null ? data!.data!.first.image! : selectedCountry!.image!,height: 35,width: 35,),
                                SizedBox(width: 10,),
                                Text(
                                    "${selectedCountry == null ? data!.data!.first.code : selectedCountry!.code}"),
                              ],
                            ),
                          )
                        ],
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFFF3F3F3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('email')}"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      TextField(
                        controller: passwordController,
                        decoration: InputDecoration(
                            filled: true,
                            focusColor: Color(0xFFF3F3F3),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFFB9B9B9))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide: BorderSide(color: Colors.blue)),
                            hintText:
                                "${AppLocalizations.of(context)!.translate('password')}"),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),


                      Text("${userAddress == null ? "" : userAddress}"),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      InkWell(
                        onTap: () {
                          _navigateAndDisplaySelection(context);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              color:  Color(0xFF66a5b4)),
                          child: Text(
                              "Selcet Location",
                              style: const TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      InkWell(
                        onTap: () => updateInfo(),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.green),
                          child: Text(
                              "${AppLocalizations.of(context)!.translate('edit')}",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top + 20))
                    ],
                  )
                ],
              ),
            ),
    );
  }
}
