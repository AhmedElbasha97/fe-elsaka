// ignore_for_file: must_be_immutable, unused_field, unnecessary_brace_in_string_interps

import 'dart:io';

import 'package:FeSekka/services/get_categories.dart';
import 'package:FeSekka/ui/logIn_screen.dart';
import 'package:FeSekka/ui/signUp_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/services/cart_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class LinearProductCard extends StatefulWidget {
  String? id;
  String? providerId;
  Function? addItemToCart;
  Function? removeItemFromCart;
  List<dynamic>? imgList;
  String? image;
  String? detailsEn;
  String? detailsAr;
  bool? isAllChecked;
  String? titleAr;
  String? titleEn;
  String? price;
  String? salePrice;
  String? video;
  int? totalAmountInCart;
  String? totalAmount;
  String? whatsappNumber;
  String shareurl;
  LinearProductCard(
      {this.id,
      this.providerId,
      this.image = "",
      this.salePrice,
      this.totalAmount,
      this.totalAmountInCart,
      this.removeItemFromCart,
      this.addItemToCart,
      this.imgList,
      this.isAllChecked,
      this.titleEn,
      this.titleAr,
      this.price,
      this.video,
      this.detailsEn,
      this.whatsappNumber,
      this.detailsAr,
        required this.shareurl,});

  @override
  _LinearProductCardState createState() => _LinearProductCardState();
}

class _LinearProductCardState extends State<LinearProductCard> {
  int? totalAmount;
   List<Widget>? child;
  int _current = 0;
  bool? checkBoxValue;

  // VideoPlayerController _controller;
  late YoutubePlayerController _controller;

  bool isLoadingVideo = false;
  bool _isPlayerReady = false;
  List<Widget> dotsList = [];
  String? token;
  makingDotsForCarouselSlider(int activeIndex){
    int productLength = widget.imgList!.length??0;
    dotsList = [];
    for(int i=0;i<productLength;i++){
      dotsList.add(
          Padding(
            padding: const EdgeInsets.all(3.0),
            child: Container(
                width:10,
                height:10,
                decoration:BoxDecoration(
                  shape:BoxShape.circle,
                  color:activeIndex == i
                      ? Color(0xFF0D986A)
                      : Color(0xFFD8D8D8)),
                )


            )
      );

    }
    setState(() {

    });
  }
  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    print(token);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    '${AppLocalizations.of(context)!.translate('signInErrorMsg')}'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text(
                  '${AppLocalizations.of(context)!.translate('newUser')}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                      isCheck: true,
                    ),
                  ))
                      .then((value) {
                    checkToken();
                    setState(() {});
                  });
                },
              ),
            ),
            Center(
              child: TextButton(
                child: Text(
                    '${AppLocalizations.of(context)!.translate('signIn')}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                    builder: (context) => LogInScreen(
                      isCheck: true,
                    ),
                  ))
                      .then((value) {
                    checkToken();
                    setState(() {});
                  });
                },
              ),
            ),
            Center(
              child: TextButton(
                child: Text('${AppLocalizations.of(context)!.translate('back')}',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }

  static List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }

  whatsapp(String contact) async {

      try {
        if (Platform.isIOS) {
          var iosUrl = "https://wa.me/$contact?text=${Uri.parse(
          "I saw a service ${widget.titleEn} In the application. Car Serv.\n في تطبيق. كار سيرف. ${widget.titleAr} رأيت خدمة ")}  \n ${widget.shareurl}";
          await launchUrl(Uri.parse(iosUrl));
        }
        else {
          var androidUrl = "whatsapp://send?phone=$contact&text= ${widget.shareurl}  \n I saw a service ${widget.titleEn} In the application. Car Surv.\n في تطبيق. كار سيرف. ${widget.titleAr} رأيت خدمة " ;

          print(widget.shareurl);
          await launchUrl(Uri.parse(androidUrl));
        }
      } on Exception {

      }
    }


  photoSlider() {
    child = widget.imgList!.map(

      (e) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Image.network(e, fit: BoxFit.cover, width: 1000.0),
          ),
        );
      },
    ).toList();
  }

  moreDialog() {
    makingDotsForCarouselSlider(0);
    showDialog(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
          builder: (context, setState) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        if (widget.video!.isNotEmpty) _controller.pause();
                        Navigator.of(context).pop();
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  child == null || child!.isNotEmpty
                      ? CarouselSlider(
                          items: child,
                          options: CarouselOptions(
                            autoPlay: true,
                            enlargeCenterPage: true,
                            aspectRatio: 2.0,
                            onPageChanged: (index, reason) {
                              _current = index;
                              makingDotsForCarouselSlider(index);
                              setState(() {


                              });
                            },
                          ),
                        )
                      : Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dotsList,
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  widget.video!.isNotEmpty
                      ? InkWell(
                          onTap: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                          child: SizedBox(
                            height: 200,
                            child: YoutubePlayer(
                              controller: _controller,
                              showVideoProgressIndicator: true,
                              aspectRatio: 16 / 9,
                            ),
                          ))
                      : Container(),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Text(
                    "${Localizations.localeOf(context).languageCode == "en" ? widget.titleEn : widget.titleAr}",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.topRight,
                    child: Text(
                      "${Localizations.localeOf(context).languageCode == "en" ? widget.detailsEn : widget.detailsAr}",
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
          }
      ),
    );
  }

  photoViewDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Container(
          width: 300,
          height: 300,
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                width: 300,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: CachedNetworkImage(
                  imageUrl: widget.imgList == null || widget.imgList!.isEmpty
                      ? ""
                      : widget.imgList!.first,
                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  addItemToCart() async {
    CartServices().addToCart(widget.id);
  }

  decreaseItemFromCart(int? newQuantity) async {
    await CartServices().decreaseFromCart(widget.id, newQuantity);
  }

  removeItemFromCart() async {
    await CartServices().removeFromCart(widget.id);
  }

  @override
  void initState() {
    super.initState();
    if (widget.video!.isNotEmpty)
      _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId("${widget.video}")!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
          ));

    if (widget.imgList!.isNotEmpty) photoSlider();

    if (widget.totalAmount == null || widget.totalAmount!.isEmpty) {
      totalAmount = widget.totalAmountInCart;
    } else {
      totalAmount = int.parse(widget.totalAmount!);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.all(Radius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.19,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 3),
                    child: Text(
                      "${Localizations.localeOf(context).languageCode == "en" ? widget.titleEn : widget.titleAr}",
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.red[900],
                          fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.3,
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5)),
                                border: Border.all(color: Colors.black)),
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: totalAmount == 0
                                ? InkWell(
                                    onTap: () async {
                                      await checkToken();
                                      if (token == "") {
                                        _showMyDialog();
                                      } else {
                                        widget.addItemToCart!();
                                        addItemToCart();
                                        totalAmount=totalAmount != null?totalAmount:0+1;
                                        setState(() {});
                                      }
                                    },
                                    child: Text(
                                      "Add +",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          widget.addItemToCart!();
                                          addItemToCart();
                                          totalAmount=totalAmount != null?totalAmount:0+1;
                                          print(widget.totalAmount);
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text(
                                            "+",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        color: Colors.grey,
                                        child: Text(
                                          "${totalAmount}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (totalAmount! > 0) {
                                            widget.removeItemFromCart!();
                                            totalAmount=totalAmount != null?totalAmount:0-1;
                                            decreaseItemFromCart(totalAmount);
                                            if (totalAmount == 0) {
                                              removeItemFromCart();
                                            }
                                            setState(() {});
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10),
                                          alignment: Alignment.center,
                                          child: Text("-",
                                              style: TextStyle(fontSize: 25)),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: 30,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.black)),
                              child: double.parse(widget.salePrice!) == 0
                                  ? Text(
                                      "${widget.price} .Qr",
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(fontSize: 14),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(" Qr.",
                                              style: TextStyle(fontSize: 13)),
                                          Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              Text(
                                                "${widget.price}",
                                                textDirection:
                                                    TextDirection.ltr,
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.grey),
                                              ),
                                              Positioned(
                                                bottom: 3,
                                                child: Text(
                                                  "_____________",
                                                  style: TextStyle(
                                                      color: Colors.blue),
                                                ),
                                              )
                                            ],
                                          ),
                                          Text(
                                            "${widget.salePrice} ",
                                            textDirection: TextDirection.ltr,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    )),
                        ],
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              GetCategories().sendClickCount(
                                  widget.providerId, "whatsapp");
                              whatsapp(
                                 widget.whatsappNumber??"");
                            },
                            child: Container(
                              height: 30,
                              child: Image.asset(
                                "assets/icon/whatsapp.png",
                              ),
                            ),
                          ),
                          Padding(padding: EdgeInsets.symmetric(vertical: 5)),
                          InkWell(
                            onTap: () {
                              moreDialog();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              height: 30,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: Colors.black)),
                              child: Text(
                                  "${AppLocalizations.of(context)!.translate('more')}",
                                  style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => photoViewDialog(),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.28,
                height: MediaQuery.of(context).size.height * 0.145,
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(color: Colors.black)),
                margin: EdgeInsets.only(left: 10),
                child: CachedNetworkImage(
                  imageUrl: widget.imgList == null || widget.imgList!.isEmpty
                      ? ""
                      : widget.imgList!.first,
                  placeholder: (context, url) => SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    height: MediaQuery.of(context).size.height * 0.1,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: CircularProgressIndicator(),
                    ),
                  ),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
