// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/model/provider/authResult.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/map_screen.dart';
import 'package:FeSekka/ui/providerScreens/OrdersScreen.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:image_picker/image_picker.dart';

class SignUpProviderScreen extends StatefulWidget {
  @override
  _SignUpProviderScreenState createState() => _SignUpProviderScreenState();
}

class _SignUpProviderScreenState extends State<SignUpProviderScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController selectedPlaceController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();

  Country? countriesData;
  Datum? selectedCountry;
  bool loading = true;

  final picker = ImagePicker();
  ImageSource imgSrc = ImageSource.gallery;
  File? img;
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
      for(var item in countriesData!.data!){
        if(item.titleen?.toLowerCase()==country?.toLowerCase()) {
          selectedCountry=item;
          print(selectedCountry);
        }

      }
    });
    // this will return country name
  }
  getCountry() async {
    countriesData = await AppInfoService().getCountries();
    try {
      selectedCountry =
          countriesData!.data!.firstWhere((element) => element.titlear == "قطر");
      saveCountry(selectedCountry!);
    } catch (e) {
      if (countriesData != null && countriesData!.data!.isNotEmpty) {
        selectedCountry = countriesData!.data!.first;
      }
    }
    getCountryName();
    loading = false;
    setState(() {});
  }

  DateTime dateTime = DateTime.now();
  bool nameError = false;
  bool emailError = false;
  bool phoneError = false;
  bool passwordError = false;
  // late PickResult selectedPlace;
  TextEditingController addressController = TextEditingController();
  Position? position;
  final ImagePicker _picker = ImagePicker();
  getLocation() async {
    // position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
  Future<void> getImageFromUserThroughCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    img = File(image!.path);
    setState(() {

    });
  }

  //get image from user through gallery
  Future<void> getImageFromUserThroughGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
    setState(() {

    });
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
    loading = true;
    setState(() {});
    if (nameController.text.isEmpty)
      nameError = true;
    else
      nameError = false;
    if (whatsAppController.text.isEmpty)
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
    if (!nameError && !phoneError && !passwordError) {
      Authresult response = await ServiceProviderService()
          .serviceProvidersignup(
              username: nameController.text,
              mobile: selectedCountry == null
                  ? "${selectedCountry!.code}${phoneController.text}"
                  : phoneController.text,
              password: passwordController.text,
              whatsApp: selectedCountry == null
                  ? "${selectedCountry!.code}${whatsAppController.text}"
                  : whatsAppController.text,
              lat: position == null ? "${0.0}" : "${position!.latitude}",
              long: position == null ? "${0.0}" : "${position!.longitude}",
              country:
                  selectedCountry == null ? null : selectedCountry!.countryId,
              img: img == null ? null : File(img!.path));
      if (response != null && response.status!) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => OrderScreen(),
        ));
      } else {
        loading = false;
        setState(() {});
        final snackBar = SnackBar(content: Text('${response.message}'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      loading = false;
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    getCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF0D986A),
          title: Text(
            "${AppLocalizations.of(context)!.translate('signUpAsProvider')}",
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
        body: loading
            ? Loader()
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: InkWell(
                        onTap: () async {
                          bool? done = await selectImageSrc() ;
                          if (done??false) {
                            if(imgSrc == ImageSource.camera) {
                            await getImageFromUserThroughCamera();
                            }else{
                            await getImageFromUserThroughGallery();
                            }
                            setState(() {});
                          }
                        },
                        child: Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Color(0xFFB9B9B9)),
                              color: Color(0xFFF3F3F3)),
                          alignment: Alignment.center,
                          child: img == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                )
                              : Image.file(File(img!.path)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFF0D986A))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFF0D986A))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                            controller: whatsAppController,
                            textDirection: TextDirection.ltr,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Color(0xFF0D986A))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Color(0xFF0D986A))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                hintText: "WhatsApp"),
                          ),
                        ),
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
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${value.code}',
                                                    textAlign: TextAlign.start,
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${value.image}"),
                                                  ),
                                                ],
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 45,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(color: Color(0xFF0D986A)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      selectedCountry == null
                                          ? "${countriesData == null ? "" : countriesData!.data!.isEmpty ? "" : countriesData!.data!.first.code}"
                                          : selectedCountry!.code!,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20),
                                      textAlign: TextAlign.start,
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: CachedNetworkImage(
                                          imageUrl: selectedCountry == null
                                              ? "${countriesData!.data!.isEmpty ? "" : countriesData!.data!.first.image}"
                                              : "${selectedCountry!.image}"),
                                    )
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                    emailError
                        ? Text(
                            "please enter your WhatsApp",
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: TextField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 25,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Color(0xFF0D986A))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Color(0xFF0D986A))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.green)),
                                hintText:
                                    "${AppLocalizations.of(context)!.translate('phoneNumber')}"),
                          ),
                        ),
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
                                                style: TextStyle(fontSize: 13),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    '${value.code}',
                                                    textAlign: TextAlign.start,
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    width: 15,
                                                  ),
                                                  Container(
                                                    width: 30,
                                                    height: 30,
                                                    child: CachedNetworkImage(
                                                        imageUrl:
                                                            "${value.image}"),
                                                  ),
                                                ],
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
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: 45,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(color: Color(0xFF0D986A)),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      selectedCountry == null
                                          ? "${countriesData == null ? "" : countriesData!.data!.isEmpty ? "" : countriesData!.data!.first.code}"
                                          : selectedCountry!.code!,
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 20),
                                      textAlign: TextAlign.start,
                                    ),
                                    Container(
                                      width: 20,
                                      height: 20,
                                      child: CachedNetworkImage(
                                          imageUrl: selectedCountry == null
                                              ? "${countriesData!.data!.isEmpty ? "" : countriesData!.data!.first.image}"
                                              : "${selectedCountry!.image}"),
                                    )
                                  ],
                                ),
                              )),
                        ),
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFF0D986A))),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                borderSide:
                                    BorderSide(color: Color(0xFF0D986A))),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
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
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Color(0xFF0D986A))),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Color(0xFF0D986A))),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.green)),
                                hintText:
                                    "your address to deliver our products to it",
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
                          color: Color(0xFF0D986A),
                        ),
                        child: Text(
                            "${AppLocalizations.of(context)!.translate('login')}",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 20))
                  ],
                ),
              ));
  }

  Future<bool?> selectImageSrc() async {
    bool? done = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              title: Center(
                  child:
                      Text(AppLocalizations.of(context)!.translate('select')!)),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.camera_alt),
                          Text(
                              AppLocalizations.of(context)!.translate('camera')!),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.camera;
                        Navigator.pop(context, true);
                      },
                    ),
                    MaterialButton(
                      child: Row(
                        children: <Widget>[
                          Icon(Icons.photo),
                          Text(
                              AppLocalizations.of(context)!.translate('galary')!),
                        ],
                      ),
                      onPressed: () {
                        imgSrc = ImageSource.gallery;
                        Navigator.pop(context, true);
                      },
                    )
                  ],
                ),
              ],
            ));
    return done;
  }
}
