// ignore_for_file: must_be_immutable

import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/model/provider/authResult.dart';
import 'package:FeSekka/model/provider/profileData.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/map_screen.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class EditProfileScreen extends StatefulWidget {
  ProfileData? data;
  EditProfileScreen({this.data});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? userAddress;
  LatLng? selectedPlace;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  bool isLoading = false;
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

  getUserData() async {
    await getCountry();
    loading = false;
    setState(() {});
    nameController.text = widget.data!.name!;
    phoneController.text = widget.data!.mobile!;
    whatsAppController.text = widget.data!.whatsapp!;
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
    selectedPlace=LatLng(result.latitude, result.longitude);
    setState(() {});
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(address)));
  }
  updateInfo() async {
    try {
      Authresult result = await ServiceProviderService().serviceProvideredit(
          mobile: phoneController.text,
          password:
              passwordController.text == "" ? null : passwordController.text,
          username: nameController.text,
          whatsApp: whatsAppController.text,
          lat: selectedPlace == null
              ? widget.data!.lat
              : "${selectedPlace?.latitude}",
          long: selectedPlace == null
              ? widget.data!.long
              : "${selectedPlace?.longitude}",
          country: selectedCountry == null ? null : selectedCountry!.countryId);
      loading = false;
      setState(() {});
      if (result != null && result.status!) {
        Navigator.of(context).pop();
      } else {
        loading = false;
        setState(() {});
        final snackBar = SnackBar(content: Text('${result.message}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on DioError catch (e) {
      loading = false;
      setState(() {});
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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                        TextField(
                          controller: phoneController,
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
                                  "${AppLocalizations.of(context)!.translate('phoneNumber')}"),
                        ),
                        Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top)),
                        TextField(
                          controller: whatsAppController,
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
                              hintText: "WhatsApp"),
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
                        Padding(
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
                                          padding: const EdgeInsets.all(8.0),
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
                                        onPressed: (_) {
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  border: Border.all(color: Color(0xFF66a5b4)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
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
                                            color: Colors.grey[600],
                                            fontSize: 20),
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
            ),
    );
  }
}
