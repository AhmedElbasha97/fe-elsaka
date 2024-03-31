// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/countries.dart';
import 'package:FeSekka/model/main_model.dart';
import 'package:FeSekka/model/provider/authResult.dart';
import 'package:FeSekka/model/provider/profileData.dart';
import 'package:FeSekka/model/provider/subcategoryProvider.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/map_screen.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/zones_model.dart';
import '../../services/get_categories.dart';

class EditProfileScreen extends StatefulWidget {
  ProfileData? data;
  EditProfileScreen({this.data});
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String? userAddress;
  LatLng? selectedPlace;
  List<String> garageList = [
    "in","out","both","parts"
  ];
  List<String> chosenZoneId = [];

  List<ZonesModel>? zones = [];
  String chosenGarageValue = "";
  String chosenGarageTitle = "";

  List<String?> mainCats = [];
  List<MainCategory> catList = [];
  SubCategory? selectedCategory;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController whatsAppController = TextEditingController();
  bool isLoading = false;
  Country? countriesData;
  Datum? selectedCountry;
  bool loading = true;
  XFile? image;
  final picker = ImagePicker();
  ImageSource imgSrc = ImageSource.gallery;
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  getCountry() async {
    catList = await GetCategories().getMainCategory();
    countriesData = await AppInfoService().getCountries();
    zones = await AppInfoService().getZones();
    try {
      selectedCountry =
          countriesData!.data!.firstWhere((element) => element.titlear == "قطر");
      saveCountry(selectedCountry!);
    } catch (e) {}
    getCountryName();
    loading = false;
    setState(() {});
  }
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
      for (var item in countriesData!.data!) {
        if (item.titleen?.toLowerCase() == country?.toLowerCase()) {
          selectedCountry = item;
          print(selectedCountry);
        }
      }
    });
    // this will return country name
  }
    Future<void> getImageFromUserThroughCamera() async {
      image = await _picker.pickImage(source: ImageSource.camera);
      setState(() {});
    }

    //get image from user through gallery
    Future<void> getImageFromUserThroughGallery() async {
      image = await _picker.pickImage(source: ImageSource.gallery);
      setState(() {});
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
  getPhoto(int index, ImageSource src) async {
    if(imgSrc == ImageSource.camera) {
      await getImageFromUserThroughCamera();
      setState(() {});
    }else{
      await getImageFromUserThroughGallery();
      setState(() {});
    }
    if (image != null) {
      if (_images.isNotEmpty) {
        if (_images.asMap()[index] == null) {
          print('in add');
          _images.add(File(image!.path));
          setState(() {});
        } else {
          print('in insert');
          _images[index] = File(image!.path);
          setState(() {});
        }
      } else

        _images.add(File(image!.path));
      print(index);

    }
  }

  getUserData() async {
    await getCountry();
    loading = false;
    setState(() {});
    mainCats = widget.data?.mainCategoryId??[];
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
          mainCats: mainCats,

          lat: selectedPlace == null
              ? widget.data!.lat
              : "${selectedPlace?.latitude}",
          long: selectedPlace == null
              ? widget.data!.long
              : "${selectedPlace?.longitude}",
          country: selectedCountry == null ? null : selectedCountry!.countryId,
          garage: chosenGarageValue,
        zoneId:   chosenZoneId

      );
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
    List<String> garageListTitle = [AppLocalizations.of(context)!.translate('garageTap1')!,AppLocalizations.of(context)!.translate('garageTap2')!,AppLocalizations.of(context)!.translate('garageTap3')!,AppLocalizations.of(context)!.translate('garageTap4')!];
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
                    InkWell(
                      onTap: () async {
                        bool? done = await selectImageSrc();
                        if (done??false) {
                          await getPhoto(0, imgSrc);
                          setState(() {
                          });
                        }
                        setState(() {
                        });
                      },
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                                border: Border.all(color: Color(0xFFB9B9B9)),
                                color: Color(0xFFF3F3F3)),
                            alignment: Alignment.center,
                            child: widget.data?.image != null?CachedNetworkImage(
                              imageUrl: widget.data?.image??"",
                              placeholder: (context, url) => SizedBox(
                                width: 100,
                                height: 100,
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                              fit: BoxFit.fill,
                            ):_images.asMap()[0] == null
                                ? Icon(
                              Icons.camera_alt,
                              size: 30,
                            )
                                : Image.file(_images[0]),
                          )
                        ],
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
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                              onTap: () {
                                showAdaptiveActionSheet(
                                  context: context,
                                  title: Center(
                                    child: Text(
                                      "${AppLocalizations.of(context)!.translate('mainCat')}",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  actions:
                                  catList.map<BottomSheetAction>((MainCategory value) {
                                    return BottomSheetAction(
                                        title: Padding(
                                            padding:
                                            const EdgeInsets.only(right: 10, left: 10),
                                            child: CheckboxListTile(
                                              title: Text(
                                                '${Localizations.localeOf(context).languageCode == "en" ? value.titleen : value.titlear}',
                                              ),
                                              value: mainCats.contains(value.mainCategoryId),
                                              onChanged: (newValue) {
                                                if (mainCats.contains(value.mainCategoryId)) {
                                                  mainCats.remove(value.mainCategoryId);
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                } else {
                                                  mainCats.add(value.mainCategoryId);
                                                  setState(() {});
                                                  Navigator.of(context).pop();
                                                }
                                              },
                                              controlAffinity: ListTileControlAffinity
                                                  .leading, //  <-- leading Checkbox
                                            )),
                                        onPressed: (_) {
                                          if (mainCats.contains(value.mainCategoryId)) {
                                            mainCats.remove(value.mainCategoryId);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          } else {
                                            mainCats.add(value.mainCategoryId);
                                            setState(() {});
                                            Navigator.of(context).pop();
                                          }
                                        });
                                  }).toList(),
                                );
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                height: 65,
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(color:Color(0xFF0D986A)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.6,
                                        child: Text(

                                          selectedCategory == null
                                              ? "${AppLocalizations.of(context)!.translate('mainCatSelectionForEdit')}"
                                              : Localizations.localeOf(context).languageCode ==
                                              "en"
                                              ? "${selectedCategory!.titleen}"
                                              : "${selectedCategory!.titlear}",
                                          style:
                                          TextStyle(color: Colors.grey[600], fontSize: 15),
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                        ),
                                      ),

                                    ],
                                  ),
                                ),
                              )),
                        ),
                        Padding(padding: EdgeInsets.only(top: 25)),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PopupMenuButton<String>(
                            itemBuilder: (context) =>
                            [
                              PopupMenuItem(
                                value:garageList[0],
                                textStyle: TextStyle(
                                    color:  Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                onTap: (){
                                  chosenGarageTitle=garageListTitle[0];
                                  chosenGarageValue=garageList[0];
                                  setState(() {
                                  });
                                },
                                child: SizedBox(
                                  width:MediaQuery.of(context).size.width*0.9,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            garageListTitle[0],
                                            style: TextStyle(
                                                color:  Colors.grey[700],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color:  Colors.grey[700],
                                        height: 1,
                                        thickness: 2,
                                        endIndent: 0,
                                        indent: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value:garageList[1],
                                textStyle: TextStyle(
                                    color:  Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                onTap: (){
                                  chosenGarageTitle=garageListTitle[1];
                                  chosenGarageValue=garageList[1];
                                  setState(() {

                                  });
                                },
                                child: SizedBox(
                                  width:MediaQuery.of(context).size.width*0.9,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            garageListTitle[1],
                                            style: TextStyle(
                                                color:  Colors.grey[700],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color:  Colors.grey[700],
                                        height: 1,
                                        thickness: 2,
                                        endIndent: 0,
                                        indent: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value:garageList[2],
                                textStyle: TextStyle(
                                    color:  Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                onTap: (){

                                  chosenGarageTitle=garageListTitle[2];
                                  chosenGarageValue=garageList[2];
                                  setState(() {

                                  });
                                },
                                child: SizedBox(
                                  width:MediaQuery.of(context).size.width*0.9,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            garageListTitle[2],
                                            style: TextStyle(
                                                color:  Colors.grey[700],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color:  Colors.grey[700],
                                        height: 1,
                                        thickness: 2,
                                        endIndent: 0,
                                        indent: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              PopupMenuItem(
                                value:garageList[3],
                                textStyle: TextStyle(
                                    color:  Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                                onTap: (){

                                  chosenGarageTitle=garageListTitle[3];
                                  chosenGarageValue=garageList[3];
                                  setState(() {

                                  });
                                },
                                child: SizedBox(
                                  width:MediaQuery.of(context).size.width*0.9,
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            garageListTitle[3],
                                            style: TextStyle(
                                                color:  Colors.grey[700],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),

                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Divider(
                                        color:  Colors.grey[700],
                                        height: 1,
                                        thickness: 2,
                                        endIndent: 0,
                                        indent: 0,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ]
                            ,

                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                height: MediaQuery.of(context).size.height*0.07,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black,width: 1)
                                ),
                                child:   Center(
                                    child:  Text(
                                      chosenGarageTitle==""?"${AppLocalizations.of(context)!.translate('selectingGarageTitle')}":chosenGarageTitle  ,
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(top: 25)),
                    
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: PopupMenuButton<String>(
                            itemBuilder: (context) =>
                                zones!.map((e){
                                  return  PopupMenuItem(
                                    value:e.zoneId,
                                    textStyle: TextStyle(
                                        color:  Colors.grey[700],
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                    onTap: (){
                                      if(chosenZoneId.contains( e.zoneId)){
                                        chosenZoneId.remove(e.zoneId);
                                      }else{
                                        chosenZoneId.add(e.zoneId??"");
                                      }
                                      setState(() {
                                      });
                                    },
                                    child: SizedBox(
                                      width:MediaQuery.of(context).size.width*0.9,
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              chosenZoneId.contains( e.zoneId)?Container(
                                                height: 30.0,
                                                width: 30.0,
                                                decoration: BoxDecoration(
                                                  color: Color(0xFF66a5b4),

                                                  borderRadius: const BorderRadius.all( Radius.circular(25.0)),
                                                ),
                                                child: Center(
                                                  child: Icon( Icons.done,color: Colors.white,),
                                                ),
                                              ):
                                              Container(
                                                height: 30.0,
                                                width: 30.0,
                                                decoration: BoxDecoration(
                                                  color:  Colors.white,
                                                  border: Border.all(
                                                      width: 2.0,
                                                      color:  Color(0xFF66a5b4)),
                                                  borderRadius: const BorderRadius.all( Radius.circular(25.0)),
                                                ),

                                              ),
                                              Text(
                                                '${Localizations.localeOf(context).languageCode == "en" ?e.titleEn:e.titleAr}',
                                                style: TextStyle(
                                                    color:  Colors.grey[700],
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Divider(
                                            color:  Colors.grey[700],
                                            height: 1,
                                            thickness: 2,
                                            endIndent: 0,
                                            indent: 0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList()
                            ,

                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                height: MediaQuery.of(context).size.height*0.07,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.black,width: 1)
                                ),
                                child:   Center(
                                    child:  Text(
                                      "${AppLocalizations.of(context)!.translate('zoneTitle1')}",
                                      style: TextStyle(
                                          color: Colors.grey[700],
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15),
                                    )
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
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
