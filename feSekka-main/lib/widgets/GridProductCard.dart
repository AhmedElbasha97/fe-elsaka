// ignore_for_file: must_be_immutable

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

class GridProductCard extends StatefulWidget {
  String? id;
  String? providerId;
  Function? addItemToCart;
  Function? removeItemFromCart;
  List<dynamic>? imgList;
  String image;
  String? detailsEn;
  String? detailsAr;
  bool? isAllChecked;
  bool hideCheckBox;
  bool checkBoxMark;
  String? titleAr;
  String? titleEn;
  String? price;
  String? video;
  String? whatsappNumber;
  int? totalAmount;

  GridProductCard(
      {this.id,
      this.providerId,
      this.image = "",
      this.totalAmount = 0,
      this.removeItemFromCart,
      this.addItemToCart,
      this.imgList,
      this.isAllChecked,
      this.hideCheckBox = false,
      this.titleEn,
      this.titleAr,
      this.price,
      this.video,
      this.checkBoxMark = false,
      this.detailsEn,
      this.detailsAr,
      this.whatsappNumber});

  @override
  _GridProductCardState createState() => _GridProductCardState();
}

class _GridProductCardState extends State<GridProductCard> {
  int? totalAmount = 0;
  List? child;
  int _current = 0;
  bool? checkBoxValue;

  YoutubePlayerController? _controller;

  bool isLoadingVideo = false;
  String token = "";

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

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  photoSlider() {
    child = map<Widget>(
      widget.imgList!,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: Image.network(i, fit: BoxFit.cover, width: 1000.0),
          ),
        );
      },
    ).toList();
  }

  moreDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
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
                      // if (widget.video.isNotEmpty) _controller.pause();
                      Navigator.of(context).pop();
                    },
                    icon: Icon(
                      Icons.clear,
                      color: Colors.red,
                    ),
                  ),
                ),
                child!.isNotEmpty
                    ? CarouselSlider(
                        items: child as List<Widget>?,
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 2.0,
                          onPageChanged: (index, reason) {
                            setState(() {
                              _current = index;
                              print('in the slider $_current');
                            });
                          },
                        ),
                      )
                    : Container(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: map<Widget>(
                    widget.imgList!,
                    (index, url) {
                      return Container(
                        width: 8.0,
                        height: 8.0,
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 5.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _current == index
                                ? Color(0xFF0D986A)
                                : Color(0xFFD8D8D8)),
                      );
                    },
                  ) as List<Widget>,
                ),
                Padding(padding: EdgeInsets.only(top: 10)),
                widget.video!.isNotEmpty
                    ? InkWell(
                        onTap: () {
                          setState(() {
                            _controller!.value.isPlaying
                                ? _controller!.pause()
                                : _controller!.play();
                          });
                        },
                        child: SizedBox(
                          height: 200,
                          child: YoutubePlayer(
                            controller: _controller!,
                            showVideoProgressIndicator: true,
                            aspectRatio: 16 / 9,
//                    onReady: (){
//                      _controller.addListener(listener);
//                    },
                          ),
                        ))
                    : Container(),

//                  Center(
//                    child: _controller.value.initialized
//                        ? AspectRatio(
//                      aspectRatio: _controller.value.aspectRatio,
//                      child: VideoPlayer(_controller),
//                    )
//                        : Container(),
//                  ),
//                         ),
//                       )
//                     : Container(),
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
                  imageUrl: widget.image.isEmpty
                      ? widget.imgList!.isEmpty
                          ? ""
                          : widget.imgList!.first
                      : widget.image,
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

//  initVideo(){
//    if(widget.video.isNotEmpty){
//      _controller = VideoPlayerController.network(
//          '${widget.video}')
//        ..initialize().then((_) {
//          // Ensure the first frame is shofter the wn avideo is initialized, even before the play button has been pressed.
//          setState(() {});
//        });
//      _controller.setLooping(true);
//    }
//  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.video!.isNotEmpty)
      _controller = YoutubePlayerController(
          initialVideoId: YoutubePlayer.convertUrlToId("${widget.video}")!,
          flags: YoutubePlayerFlags(
            autoPlay: true,
          ));

    totalAmount = widget.totalAmount;

    if (widget.imgList!.isNotEmpty) photoSlider();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.6,
      color: Colors.white,
      child: Column(
        children: [
          InkWell(
            onTap: () => photoViewDialog(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.14,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: CachedNetworkImage(
                imageUrl: widget.image.isEmpty
                    ? widget.imgList!.isEmpty
                        ? ""
                        : "${widget.imgList!.first}"
                    : "${widget.image}",
                placeholder: (context, url) => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CircularProgressIndicator(),
                  ),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                  "${Localizations.localeOf(context).languageCode == "en" ? widget.titleEn : widget.titleAr}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      fontSize: 14),
                  overflow: TextOverflow.ellipsis),
            ),
          ),
          Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${widget.price} QAR",
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          fontSize: 13),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    InkWell(
                      onTap: () {
                        GetCategories()
                            .sendClickCount(widget.providerId, "whatsapp");
                        _launchURL(
                            "https://wa.me/${widget.whatsappNumber}?text=رأيت خدمتك" +
                                "${widget.titleAr}" +
                                "في تطبيق كبينة");
                      },
                      child: Container(
                        height: 30,
                        child: Image.asset(
                          "assets/icon/whatsapp.png",
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    )
                  ],
                ),
              )),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              totalAmount == 0
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
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: MediaQuery.of(context).size.height * 0.040,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          color: Color(0xFF0D986A),
                        ),
                        alignment: Alignment.center,
                        child: Text("Add +",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16)),
                      ),
                    )
                  : Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: MediaQuery.of(context).size.height * 0.040,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                widget.addItemToCart!();
                                addItemToCart();
                                totalAmount=totalAmount != null?totalAmount:0+1;
                                print(widget.totalAmount);
                                setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(5),
                                    bottomRight: Radius.circular(5),
                                  ),
                                  color: Colors.black,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "+",
                                  style: TextStyle(
                                      fontSize: 35,
                                      color: Colors.white,
                                      height: 1),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              color: Color(0xFFe0e0e0),
                              alignment: Alignment.center,
                              child: Text("$totalAmount"),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                if (totalAmount! > 0) {
                                  widget.removeItemFromCart!();
                                  totalAmount=totalAmount != null?totalAmount:0-1;;
                                  decreaseItemFromCart(totalAmount);
                                  if (totalAmount == 0) {
                                    removeItemFromCart();
                                  }
                                  setState(() {});
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(5),
                                    bottomLeft: Radius.circular(5),
                                  ),
                                  color: Colors.black,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "-",
                                  style: TextStyle(
                                      fontSize: 60,
                                      color: Colors.white,
                                      height: 0.75),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 2)),
              InkWell(
                onTap: () {
                  if (_controller == null) {
                    isLoadingVideo = true;
                    setState(() {});
                    //initVideo();
                    Future.delayed(Duration(seconds: 2), () {
                      isLoadingVideo = false;
                      setState(() {});
                      moreDialog();
                    });
                  } else {
                    moreDialog();
                  }
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.height * 0.040,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Colors.black)),
                  alignment: Alignment.center,
                  child: Text(
                      "${AppLocalizations.of(context)!.translate('more')}",
                      style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}