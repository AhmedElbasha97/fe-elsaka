// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:dio/dio.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/category.dart';
import 'package:FeSekka/services/checkout.dart';
import 'package:FeSekka/splash_screen.dart';
import 'package:FeSekka/ui/terms_screen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'map_screen.dart';

class PaymentScreen extends StatefulWidget {
  List<String?>? cart;
  int? totalPrice;
  int? isSale;
  List<WrokHours>? shifts;
  String? name;

  PaymentScreen(
      {this.cart, this.totalPrice, this.isSale, this.shifts, this.name});

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String? token;
  bool _agree1 = false;
  bool _agree2 = false;
  bool _agree3 = false;
  bool isLoading = true;
  bool isPaying = false;
  DateTime dateTime = DateTime.now();
  String birthDate =
      "${DateTime.now().day} / ${DateTime.now().month} / ${DateTime.now().year} ";
  // PickResult? selectedPlace;
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController addressNumberController = TextEditingController();
  TextEditingController buildingNumberController = TextEditingController();
  TextEditingController streetNumberController = TextEditingController();
  TextEditingController notesController = TextEditingController();

  String? lat;
  String? long;
  int selcetedIndex = 0;
  late Position position;
  String payment = "cash";

  getLocation() async {
    // position = await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
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
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(_agree3 ? "تم ارسال طلبك" : 'تم الشراء'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(_agree3
                    ? "نم ارسال طلبك في انتظار قبول الطلب"
                    : 'تم الشراء بنجاح'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text(
                  'تم',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => SplashScreen(),
                  ));
                },
              ),
            ),
          ],
        );
      },
    );
  }

  checkout() async {
    await Checkout().checkout(
        name: nameController.text,
        mobile: mobileController.text,
        address: addressController.text,
        email: emailController.text,
        birthDate: birthDate,
        totalPrice: widget.totalPrice,
        isSale: widget.isSale,
        token: token,
        long:long,
        lat:lat,
        // long:
        //     selectedPlace == null ? long : selectedPlace!.geometry!.location.lng as String?,
        // lat: selectedPlace == null ? lat : selectedPlace!.geometry!.location.lat as String?,
        streetNumber: streetNumberController.text,
        buildingNumber: buildingNumberController.text,
        discretNumber: addressNumberController.text,
        selectedShift: widget.shifts == null || widget.shifts!.isEmpty
            ? null
            : widget.shifts![selcetedIndex].id,
        paymentType: payment,
        notes: notesController.text);
    isPaying = false;
    setState(() {});
    _showMyDialog();
  }

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    await getLocation();
    Response response = await Dio().post("https://carserv.net/api/info",
        options: Options(headers: {"token": "$token"}));
    print('**************************');
    print(response.data);
    print('**************************');
    nameController.text = response.data['data'][0]['name'];
    emailController.text = response.data['data'][0]['email'];
    mobileController.text = response.data['data'][0]['mobile'];
    addressController.text = response.data['data'][0]['address'];
    addressController.text = response.data['data'][0]['address'];
    addressController.text = response.data['data'][0]['address'];
    lat = response.data['data'][0]['lat'];
    long = response.data['data'][0]['long'];
    isLoading = false;
    setState(() {});
    print(response.data);
  }

  @override
  void initState() {
    super.initState();
    print('******************************');
    widget.cart!.forEach((element) {
      print(element);
    });
    print('******************************');
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          "${AppLocalizations.of(context)!.translate('buyConfirm')}",
          style: TextStyle(color: Colors.black),
        ),
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
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top + 20)),
                    TextField(
                      controller: nameController,
                      style: TextStyle(color: Colors.black),
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
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
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
                      controller: mobileController,
                      style: TextStyle(color: Colors.black),
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
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
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
                      controller: emailController,
                      style: TextStyle(color: Colors.black),
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
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide: BorderSide(color: Color(0xFFB9B9B9))),
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
                    InkWell(
                      onTap: (){
                        _navigateAndDisplaySelection(context);
                      },
                      child: IgnorePointer(
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          alignment: Alignment.center,
                          child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: addressController,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "اكتب العنوان",
                                      hintStyle: TextStyle(fontSize: 18)),
                                ),
                              )),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      ((0.8 / 3) + 0.05),
                                  child: TextField(
                                    controller: addressNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        hintText: "رقم المنطقه",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400])),
                                  ),
                                ),
                                Text("/"),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.8 /
                                      3,
                                  child: TextField(
                                    controller: streetNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        hintText: "رقم الشارع",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400])),
                                  ),
                                ),
                                Text("/"),
                                SizedBox(
                                  width: MediaQuery.of(context).size.width *
                                      0.8 /
                                      3,
                                  child: TextField(
                                    controller: buildingNumberController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 0, horizontal: 10),
                                        border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(20))),
                                        hintText: "رقم المبنى",
                                        hintStyle: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[400])),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                    Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: TextField(
                              controller: notesController,
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
                                      borderSide:
                                          BorderSide(color: Colors.blue)),
                                  hintText:
                                      "${AppLocalizations.of(context)!.translate('notes')}"),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.only(
                            top: MediaQuery.of(context).padding.top)),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.5,
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Colors.black,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        "${AppLocalizations.of(context)!.translate('totalPrice')} : ${widget.totalPrice}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _agree1 = !_agree1;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _agree1
                                          ? Colors.black
                                          : Color(0xFF636363),
                                    ),
                                    borderRadius: BorderRadius.circular(50)),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 9.0,
                                  ),
                                  radius: 10.0,
                                  backgroundColor:
                                      _agree1 ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TermsScreen(),
                              ));
                            },
                            child: Text(
                              "${AppLocalizations.of(context)!.translate('termsAgree')}",
                              style: TextStyle(
                                  color: _agree1 ? Colors.black : Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25.0, top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 10),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _agree2 = !_agree2;
                                  _agree3 = !_agree2;
                                });
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _agree2
                                          ? Colors.black
                                          : Color(0xFF636363),
                                    ),
                                    borderRadius: BorderRadius.circular(50)),
                                child: CircleAvatar(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 9.0,
                                  ),
                                  radius: 10.0,
                                  backgroundColor:
                                      _agree2 ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            onTap: () async {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => TermsScreen(),
                              ));
                            },
                            child: Text(
                              "الدفع عند الاستلام",
                              style: TextStyle(
                                  color: _agree2 ? Colors.black : Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    isPaying
                        ? CircularProgressIndicator()
                        : InkWell(
                            onTap: () {
                              if (_agree1 && (_agree2 || _agree3)) {
                                isPaying = true;
                                setState(() {});
                                checkout();
                              }
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.symmetric(vertical: 15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.green,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${AppLocalizations.of(context)!.translate('buyConfirm')}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                    Padding(padding: EdgeInsets.only(top: 20)),
                  ],
                ),
              ),
            ),
    );
  }
}
