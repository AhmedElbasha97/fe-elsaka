// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'dart:io';
import 'package:map_launcher/map_launcher.dart' as mapLancher;

import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/category.dart';
import 'package:FeSekka/services/get_categories.dart';
import 'package:FeSekka/services/stats_services.dart';
import 'package:FeSekka/ui/complementsScreen.dart';
import 'package:FeSekka/ui/welcome_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:FeSekka/I10n/AppLanguage.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/cart_product.dart';
import 'package:FeSekka/model/product.dart';
import 'package:FeSekka/services/cart_services.dart';
import 'package:FeSekka/services/get_products.dart';
import 'package:FeSekka/ui/logIn_screen.dart';
import 'package:FeSekka/ui/signUp_screen.dart';
import 'package:FeSekka/widgets/GridProductCard.dart';
import 'package:FeSekka/widgets/product_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_rating/star_rating.dart';
import 'package:url_launcher/url_launcher.dart';

import '../widgets/loader.dart';
import 'cart_screen.dart';

class ProductsScreen extends StatefulWidget {
  String? categoryId;
  String? categoryName;
  List<Sub>? subCategory;
  String lang;
  String? lat;
  String? long;
  String? whatsApp;
  String? mobile;
  List<WrokHours>? shifts;
  List<String>? photos;
  String? rating;
  ProductsScreen(
      this.categoryId,
      this.categoryName,
      this.subCategory,
      this.lang,
      this.shifts,
      this.lat,
      this.long,
      this.whatsApp,
      this.mobile,
      this.rating,
      this.photos);

  @override
  _ProductsScreenState createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen>
    with SingleTickerProviderStateMixin {
  late List imgList;
  List? child;
  GoogleMapController? _mapController;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  int? totalPrice = 0;
  bool? isAllCheck;
  bool isLoading = true;
  late List<Widget> child2;
  bool isLoadingMoreData = false;
  bool isLoadingAllData = false;
  bool isSearchClicked = false;
  bool cartError = false;
  bool isLinear = true;
  bool certainCategorySelected = false;
  List<ProductModel> productModelList = <ProductModel>[];
  ScrollController? _loadMoreDataController;
  int apiPage = 1;

  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  List<String?> cart = <String?>[];
  List<CartProductModel> cartProductModelList = <CartProductModel>[];
  int totalProductsInCart = 0;
  bool errorSearch = false;
  bool searchFound = false;
  bool isHighestPriceFilterSelected = false;
  bool isLowestPriceFilterSelected = false;
  bool isDiscountFilterSelected = false;
  bool isNewFilterSelected = false;
  bool isLoadingFilter = false;
  List<Widget> dotsList = [];
  TabController? tabController;
  whatsapp(String contact) async {
    print(contact);
    String response = await StatService().whatsAppStatService(providerId: widget.categoryId??"");
    if (response == 'success') {


      try {
        if (Platform.isIOS) {
          var iosUrl = "https://wa.me/$contact?text=${Uri.parse(
              "I saw a Store ${widget
                  .categoryName} In the application. Car Serv.\n رأيت المحل ${widget
                  .categoryName}   في تطبيق كار سيرف")} ";
          await launchUrl(Uri.parse(iosUrl));
        }
        else {
          var androidUrl = "whatsapp://send?phone=$contact&text=   \n I saw a Store ${widget
              .categoryName} In the application. Car Surv.\n رأيت المحل. ${widget
              .categoryName}  في تطبيق كار سيرف";


          await launchUrl(Uri.parse(androidUrl));
        }
      } on Exception {

      }
    }
  }
  makingDotsForCarouselSlider(int activeIndex){
    int productLength = child?.length??0;
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
    setState(() {});
  }
  showLocationInGoogleMap() async {
    await mapLancher.MapLauncher.showMarker(
      mapType: Platform.isAndroid
          ? mapLancher.MapType.google: mapLancher.MapType.apple,
      coords:  mapLancher.Coords(double.parse(widget.lat??""),
          double.parse(widget.long??"")),
      title: "${widget?.categoryName}",
      description: "you can now navigate to this street",
    );
  }
  openMap() async {
    print(widget.lat);
    print(widget.long);
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return StatefulBuilder(builder: (context, StateSetter setState) {
              return Dialog(
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.9,
                    child: widget.lat == "null" || widget.lat == "" || widget.lat == null
                        ? const Center(
                      child: Text("لا يوجد موقع محدد الان"),
                    )
                        : GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: widget.lat == "null" || widget.lat == ""
                            ? const LatLng(0, 0)
                            : LatLng(
                            double.parse(widget.lat??""),
                            double.parse(widget.long??"")),
                        zoom: 19.151926040649414,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _mapController = controller;
                        setState(() {});
                      },
                      markers: {
                        Marker(
                          // This marker id can be anything that uniquely identifies each marker.
                          markerId: const MarkerId("currentState"),
                          position: widget.lat == "null" ||
                              widget.lat == ""
                              ? const LatLng(0, 0)
                              : LatLng(
                              double.parse(widget.lat??""),
                              double.parse(widget.long??"")),
                          infoWindow: InfoWindow(
                            // title is the address
                            title: "${widget.categoryName}",
                            // snippet are the coordinates of the position
                            snippet: '${widget.categoryName}',
                          ),
                          icon: BitmapDescriptor.defaultMarker,
                        )
                      },
                      liteModeEnabled: true,
                    )),
              );
            });
          },
        );
      },
    );
  }

  getCartProducts() async {
    var productModelList = await CartServices().viewCart(false);
    productModelList.forEach((element) {

      cart.add(element.id);
    });
  }

  static List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }

    return result;
  }


    _launchURL(String url,String nameOfSocialProgram) async {
    print("hiiiiiiii");
    print(url);
      if(url == "" || url == "https://wa.me/" || url == "tel:"){
        _showDialog(Localizations.localeOf(context).languageCode == "en"
            ? "the $nameOfSocialProgram is not available at the moment": " منصة $nameOfSocialProgram  غير متاحه الان  ",  Localizations.localeOf(context).languageCode == "en"
            ?"sorry":"عذرا",false);
      }
      if (await launchUrl(Uri.parse(url))) {

      } else {
        throw 'Could not launch $url';
      }
    }


  photoSlider() {
    makingDotsForCarouselSlider(0);
    child = map<Widget>(
      widget.photos!,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: i,
              fit: BoxFit.contain,
              width: 1000.0,
              placeholder: (context, url) => SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                height: MediaQuery.of(context).size.height * 0.1,
                child: FittedBox(
                  fit: BoxFit.contain,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();
  }

  Widget popUp() {
    var appLanguage = Provider.of<AppLanguage>(context);
    return CupertinoActionSheet(
      title: new Text('اللغه'),
      message: new Text('اختر اللغه'),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: new Text('English'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("en"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        ),
        CupertinoActionSheetAction(
          child: new Text('Arabic'),
          onPressed: () {
            appLanguage.changeLanguage(Locale("ar"));
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: new Text('رجوع'),
        isDefaultAction: true,
        onPressed: () {
          Navigator.pop(context, 'Cancel');
        },
      ),
    );
  }

  getMoreData() async {
    print(apiPage);
    if (apiPage != 0) {
      isLoadingMoreData = true;
      setState(() {});
      print(apiPage);
      apiPage++;
      print(apiPage);
      List<ProductModel> productModelList = <ProductModel>[];
      productModelList =
          await GetProducts().getProducts(widget.categoryId, apiPage);
      if (productModelList.isNotEmpty) {

        this.productModelList.addAll(productModelList);
      } else
        apiPage--;
      isLoadingMoreData = false;
      setState(() {});
    }
  }

  getMoreDataFromCertainCategory() async {
    print(apiPage);
    if (apiPage != 0) {
      isLoadingMoreData = true;
      setState(() {});
      print(apiPage);
      apiPage++;
      print(apiPage);
      List<ProductModel> productModelList = <ProductModel>[];
      productModelList = await GetProducts()
          .getSubCategoryProducts(widget.categoryId, apiPage);
      if (productModelList.isNotEmpty) {
        this.productModelList.addAll(productModelList);
      } else
        apiPage--;
      isLoadingMoreData = false;
      setState(() {});
    }
  }

  getProducts({bool isSwitch = false}) async {
    if (isSwitch) {
      var productModelList =
          await GetProducts().getProducts(widget.categoryId, apiPage);
      print(this.productModelList.length);
      this.productModelList.clear();
      print(this.productModelList.length);
      this.productModelList.addAll(productModelList);
      print(this.productModelList.length);
    } else {
      productModelList =
          await GetProducts().getProducts(widget.categoryId, apiPage);
    }
    print('---------------------');
    print(productModelList.length);
    print('---------------------');
    isLoading = false;
    setState(() {});
  }

  getProductsFromCertainCategory({String? subCategory}) async {
    var productModelList =
        await GetProducts().getSubCategoryProducts(subCategory, apiPage);
    print(this.productModelList.length);
    this.productModelList.clear();
    print(this.productModelList.length);
    this.productModelList.addAll(productModelList);
    print(this.productModelList.length);
    print('---------------------');
    print(productModelList.length);
    print('---------------------');
    isLoading = false;
    setState(() {});
  }

  getData() async {
    await getProducts();
    imgList = GetProducts.categoryPhotos ?? [];
    if (widget.photos != null && widget.photos!.isNotEmpty) photoSlider();
    isLoading = false;

    setState(() {});
  }

  String? token;

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? "";
    print(token);
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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

  getCartItems() async {
    cartProductModelList = await CartServices().viewCart(false);
    print('*****************');
    print(cartProductModelList.length);
    print('*****************');
    totalProductsInCart = CartServices.totalQuantity ?? 0;
    totalPrice = CartServices.totalPrice;

    print('********************************');
    print(totalPrice);
    print('********************************');
    setState(() {});
  }

  getSeachedItems() async {
    Response response = await Dio().post("https://carserv.net/api/search",
        data: {"keyword": "${searchController.text}"});
    isLoading = true;
    setState(() {});
    if (response.data['status'] == true) {
      searchFound = true;
      productModelList.clear();
      List data = response.data['data'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } else {
      errorSearch = true;
      setState(() {});
    }
    isLoading = false;
    setState(() {});
  }

  getFilterItems(
      {required bool isHighestPriceFilterSelected,
      required bool isLowestPriceFilterSelected,
      required bool isDiscountFilterSelected,
      required bool isNewFilterSelected}) async {
    String highestPriceFilter;
    String lowestPriceFilter;
    String discountFilter;
    String newFilter;

    isHighestPriceFilterSelected
        ? highestPriceFilter = "high_price"
        : highestPriceFilter = "";
    isLowestPriceFilterSelected
        ? lowestPriceFilter = "low_price"
        : lowestPriceFilter = "";
    isDiscountFilterSelected
        ? discountFilter = "discount"
        : discountFilter = "";
    isNewFilterSelected ? newFilter = "new" : newFilter = "";

    Response response =
        await Dio().post("https://carserv.net/api/search", data: {
      "filter1": "$highestPriceFilter",
      "filter2": "$lowestPriceFilter",
      "filter3": "$discountFilter",
      "filter4": "$newFilter",
    });
    isLoading = true;
    setState(() {});
    if (response.data['status'] == true) {
      searchFound = true;
      productModelList.clear();
      List data = response.data['data'];
      data.forEach((element) {
        productModelList.add(ProductModel.fromJson(element));
      });
    } else {
      errorSearch = true;
      setState(() {});
    }
    isLoading = false;
    setState(() {});
  }

  Future<void> filterDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('فلتر'),
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isHighestPriceFilterSelected =
                            !isHighestPriceFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color: isHighestPriceFilterSelected
                              ? Colors.blue
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "اعلى سعر",
                          style: TextStyle(
                              color: isHighestPriceFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isHighestPriceFilterSelected = false;
                        isLowestPriceFilterSelected =
                            !isLowestPriceFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color: isLowestPriceFilterSelected
                              ? Colors.blue
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "اقل سعر",
                          style: TextStyle(
                              color: isLowestPriceFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isDiscountFilterSelected = !isDiscountFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color: isDiscountFilterSelected
                              ? Colors.blue
                              : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "الخصومات",
                          style: TextStyle(
                              color: isDiscountFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                    InkWell(
                      onTap: () async {
                        isNewFilterSelected = !isNewFilterSelected;
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.65,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              Border.all(color: Color(0xFFCCCCCC), width: 2),
                          color:
                              isNewFilterSelected ? Colors.blue : Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          "المنتجات الجديده",
                          style: TextStyle(
                              color: isNewFilterSelected
                                  ? Colors.white
                                  : Colors.blue),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                isLoadingFilter
                    ? TextButton(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        onPressed: null,
                      )
                    : TextButton(
                        child: Text('موافق'),
                        onPressed: () async {
                          isLoadingFilter = true;
                          setState(() {});
                          if (isDiscountFilterSelected ||
                              isHighestPriceFilterSelected ||
                              isLowestPriceFilterSelected ||
                              isNewFilterSelected)
                            await getFilterItems(
                              isDiscountFilterSelected:
                                  isDiscountFilterSelected,
                              isHighestPriceFilterSelected:
                                  isHighestPriceFilterSelected,
                              isLowestPriceFilterSelected:
                                  isLowestPriceFilterSelected,
                              isNewFilterSelected: isNewFilterSelected,
                            );
                          else
                            await getProducts();
                          tabController!.animateTo(0);
                          isLoadingFilter = false;
                          setState(() {});
                          Navigator.of(context).pop();
                        },
                      ),
                TextButton(
                  child:
                      Text('${AppLocalizations.of(context)!.translate('back')}'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  List<Widget> tabsList = [];
  String? golabalSubCategory;

  initListOfTabs() {
    tabsList.add(InkWell(
      onTap: () async {
        tabController!.animateTo(0);
        certainCategorySelected = false;
        apiPage = 1;
        await getProducts(isSwitch: true);
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.black,
            child: Icon(
              Icons.category,
              color: Colors.white,
            ),
          ),
          Text(
            "${widget.lang == "en" ? "all categories" : "كل الاقسام"}",
            style: TextStyle(fontSize: 14),
          )
        ],
      ),
    ));

    for (int i = 0; i < widget.subCategory!.length; i++) {
      tabsList.add(InkWell(
        onTap: () async {
          tabController!.animateTo(i + 1);
          certainCategorySelected = true;
          apiPage = 1;
          golabalSubCategory = widget.subCategory![i].id;
          await getProductsFromCertainCategory(subCategory: golabalSubCategory);
        },
        child: Column(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage("${widget.subCategory![i].picpath}"),
            ),
            Text(
              "${widget.lang == "en" ? widget.subCategory![i].titleen : widget.subCategory![i].titlear}",
              style: TextStyle(fontSize: 14),
            )
          ],
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    tabController =
        TabController(length: (widget.subCategory!.length + 1), vsync: this);
    getCartItems();
    initListOfTabs();
    _loadMoreDataController = new ScrollController();
    _loadMoreDataController!.addListener(() async {
      if (_loadMoreDataController!.position.pixels ==
              _loadMoreDataController!.position.maxScrollExtent &&
          isAllCheck == false) {
        certainCategorySelected
            ? getMoreDataFromCertainCategory()
            : getMoreData();
      }
    });

    getData();
    checkToken();

  }
  void _showDialog(String content,String title,bool signing) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            TextButton(
              child: !signing?Text(Localizations.localeOf(context).languageCode == "en"
                  ?"Close":"اغلق"):Text(Localizations.localeOf(context).languageCode == "en"
                  ?"sign up":"تسجيل دخول",),
              onPressed: () {
                !signing?Navigator.of(context).pop(): pushPage(context,  WelcomeScreen());
              },
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[300],

          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (token!.isEmpty)
                  _showMyDialog();
                else {
                  isAllCheck = null;
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => CartScreen(
                              shifts: widget.shifts,
                              id: widget.categoryId,
                              name: widget.categoryName)))
                      .whenComplete(() async {
                    isLoadingAllData = true;
                    productModelList.clear();
                    setState(() {});
                    await getCartItems();
                    await getProducts(isSwitch: true);
                    isLoadingAllData = false;
                    setState(() {});
                  });
                }
              },
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.redAccent,
                    radius: 13,
                    child: Text(
                      "$totalProductsInCart",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                ],
              ),
            )
          ],
        ),
        body: isLoading
            ?  Loader()
            : GestureDetector(
                onTap: () => searchFocusNode.unfocus(),
                child: SingleChildScrollView(
                  controller: _loadMoreDataController,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          "${widget.categoryName}",
                          style: TextStyle(color: Colors.black, fontFamily: 'tajawal',fontSize: 20,),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(padding: EdgeInsets.symmetric(vertical: 10)),
                      child != null && child!.isNotEmpty
                          ? CarouselSlider.builder(
                        carouselController: _controller,
                        itemCount: child!.length,
                        itemBuilder: (BuildContext context, int index, int realIndex) {
                          return child![index]!;
                        },
                       options: CarouselOptions(
                       autoPlay: true,
                       enlargeCenterPage: true,
                         aspectRatio: 2.0,
                                onPageChanged: (index, reason) {
                                  _current = index;
                                  makingDotsForCarouselSlider(_current);
                                  setState(() {

                                  });
                                },
                              ),
                            )
                          : Container(),
            child != null && child!.isNotEmpty
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:dotsList,
            ):SizedBox(),
                      DefaultTabController(
                        length: tabsList.length,
                        child: PreferredSize(
                          preferredSize: Size(MediaQuery.of(context).size.width,
                              MediaQuery.of(context).size.height * 0.15),
                          child: TabBar(
                            isScrollable: true,
                            labelColor: Colors.blue,
                            unselectedLabelColor: Colors.black,
                            controller: tabController,
                            tabs: tabsList,
                          ),
                        ),
                      ),


                      Padding(padding: EdgeInsets.only(top: 20)),
                      StarRating(
                        mainAxisAlignment: MainAxisAlignment.center,
                        length: 5,
                        rating: double.parse("${widget.rating??"0"}.0"??"0.0"),
                        between: 5,
                        starSize: 30,

                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.location_on,
                              color: Color(0xFF66a5b4),
                              size: 30,
                            ),
                            onPressed: () {
                              openMap();
                            },
                          ),
                          InkWell(
                            onTap: (){
                              showLocationInGoogleMap();

                            },
                            child:Text(
                              "${AppLocalizations.of(context)!.translate('openLocation')}",
                              style: TextStyle(
                                  color: Colors.grey[700],

                                  fontSize: 18,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.grey[300],
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(
                              onTap: () {
                                whatsapp(widget.whatsApp??"");
                              },
                              child: Container(
                                height: 30,
                                child: Image.asset(
                                  "assets/icon/whatsapp.png",
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.phone,
                                color: Color(0xFF66a5b4),
                                size: 30,
                              ),
                              onPressed: () async {
                                GetCategories().sendClickCount(
                                    widget.categoryId, "mobile");
                                String response = await StatService().mobileStatService(providerId: widget.categoryId??"");
                                if(response=='success'){
                                  _launchURL("tel:${widget.mobile}","mobile");
                                }

                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.view_module,
                                color: Color(0xFF66a5b4),
                                size: 30,
                              ),
                              onPressed: () async {
                                isLoadingAllData = true;
                                setState(() {});
                                apiPage = 1;
                                certainCategorySelected
                                    ? await getProductsFromCertainCategory(
                                        subCategory: golabalSubCategory)
                                    : await getProducts(isSwitch: true);
                                isLinear = false;
                                isLoadingAllData = false;
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.format_list_bulleted,
                                color: Color(0xFF66a5b4),
                                size: 30,
                              ),
                              onPressed: () async {
                                isLoadingAllData = true;
                                setState(() {});
                                apiPage = 1;
                                certainCategorySelected
                                    ? await getProductsFromCertainCategory(
                                        subCategory: golabalSubCategory)
                                    : await getProducts(isSwitch: true);
                                isLinear = true;
                                isLoadingAllData = false;
                                setState(() {});
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.search,
                                color: isSearchClicked
                                    ? Colors.green
                                    : Color(0xFF66a5b4),
                                size: 30,
                              ),
                              onPressed: () {
                                isSearchClicked = !isSearchClicked;
                                if (isSearchClicked == false)
                                  errorSearch = false;
                                if (searchFound == true) {
                                  searchFound = false;
                                  productModelList.clear();
                                  getCartItems();
                                  getData();
                                }
                                tabController!.animateTo(0);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      errorSearch
                          ? Center(
                              child: Text("no item found"),
                            )
                          : Container(),
                      isSearchClicked
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: TextField(
                                controller: searchController,
                                focusNode: searchFocusNode,
                                textInputAction: TextInputAction.search,
                                onSubmitted: (value) {
                                  getSeachedItems();
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    disabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide:
                                            BorderSide(color: Colors.black)),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        getSeachedItems();
                                      },
                                      icon: Icon(
                                        Icons.search,
                                        color: searchFocusNode.hasFocus
                                            ? Colors.blue
                                            : Colors.grey,
                                      ),
                                    ),
                                    hintText: "search...",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 1)),
                              ),
                            )
                          : Container(),
                      isLoadingAllData
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                  Text(
                                    "جارى التحميل",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Padding(padding: EdgeInsets.only(top: 30)),
                                  CircularProgressIndicator(),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          top: MediaQuery.of(context)
                                                  .padding
                                                  .top +
                                              50)),
                                ],
                              ),
                            )
                          : productModelList == null || productModelList.isEmpty
                              ? Center(
                                  child: Text("ليس هناك منتجات متاحه الأن"),
                                )
                              : isLinear
                                  ? ListView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: productModelList.length,
                                      itemBuilder: (context, index) {
                                        print(token);
                                        return AnimationConfiguration
                                            .staggeredList(
                                                position: index,
                                                duration: const Duration(
                                                    milliseconds: 1500),
                                                child: SlideAnimation(
                                                    verticalOffset: 50.0,
                                                    child: FadeInAnimation(
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                vertical: 5,
                                                                horizontal: 5),
                                                        child:
                                                            LinearProductCard(
                                                              phoneNumber: productModelList[index]
                                                                  .provider!
                                                                  .mobile,
                                                              shareUrl: productModelList[
                                                              index].shareurl??"",
                                                          whatsappNumber:
                                                              widget.whatsApp,
                                                          id: productModelList[
                                                                  index]
                                                              .id,
                                                          providerId:
                                                              widget.categoryId,
                                                          titleEn:
                                                              productModelList[
                                                                      index]
                                                                  .titleEn,
                                                          titleAr:
                                                              productModelList[
                                                                      index]
                                                                  .titleAr,
                                                          detailsEn:
                                                              productModelList[
                                                                      index]
                                                                  .detailsEn,
                                                          detailsAr:
                                                              productModelList[
                                                                      index]
                                                                  .detailsAr,
                                                          price:
                                                              productModelList[
                                                                      index]
                                                                  .price,
                                                          video:
                                                              productModelList[
                                                                          index]
                                                                      .video ??
                                                                  "",
                                                          salePrice:
                                                              productModelList[
                                                                      index]
                                                                  .salePrice,
                                                          isAllChecked:
                                                              isAllCheck,
                                                          totalAmountInCart:
                                                              productModelList[
                                                                      index]
                                                                  .quantity,
                                                          addItemToCart:
                                                              () async {
                                                            await checkToken();
                                                            if (token == "") {
                                                              _showMyDialog();
                                                            } else {
                                                              totalProductsInCart++;
                                                              setState(() {});
                                                            }
                                                          },
                                                          removeItemFromCart:
                                                              () async {
                                                            await checkToken();
                                                            if (token == "") {
                                                              _showMyDialog();
                                                            } else {
                                                              totalProductsInCart--;
                                                              setState(() {});
                                                              Future.delayed(
                                                                  Duration(
                                                                      seconds:
                                                                          1),
                                                                  () async {
                                                                await getCartItems();
                                                                setState(() {});
                                                              });
                                                            }
                                                          },
                                                          imgList:
                                                              productModelList[
                                                                      index]
                                                                  .images, type: productModelList[index].type??"",
                                                              providerNameAr: productModelList[index].provider?.titlear??"",
                                                              providerNameEn: productModelList[index].provider?.titleen??"",
                                                        ),
                                                      ),
                                                    )));
                                      },
                                    )
                                  : GridView.builder(
                                      primary: false,
                                      shrinkWrap: true,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              childAspectRatio:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      (MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          1.7)),
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: productModelList.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 4, horizontal: 5),
                                          child: GridProductCard(
                                            shareUrl: productModelList[
                                            index].shareurl??"",
                                            id: productModelList[index].id,
                                            providerId: widget.categoryId,
                                            titleEn:
                                                productModelList[index].titleEn,
                                            titleAr:
                                                productModelList[index].titleAr,
                                            detailsEn: productModelList[index]
                                                .detailsEn,
                                            detailsAr: productModelList[index]
                                                .detailsAr,
                                            price:
                                                productModelList[index].price,
                                            video:
                                                productModelList[index].video ??
                                                    "",
                                            isAllChecked: isAllCheck,
                                            totalAmount: productModelList[index]
                                                .quantity,
                                            addItemToCart: () async {
                                              await checkToken();
                                              if (token == "") {
                                                _showMyDialog();
                                              } else {
                                                totalProductsInCart++;
                                                setState(() {});
                                              }
                                            },
                                            removeItemFromCart: () async {
                                              await checkToken();
                                              if (token == "") {
                                                _showMyDialog();
                                              } else {
                                                totalProductsInCart--;
                                                setState(() {});
                                              }
                                            },
                                            imgList: productModelList[
                                                                      index]
                                                                  .images,
                                            whatsappNumber: widget.whatsApp, type:  "${productModelList[index].type??""}",phoneNumber: productModelList[index]
                                              .provider!
                                              .mobile,
                                          ),
                                        );
                                      },
                                    ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      productModelList == null || productModelList.isEmpty
                          ? Container()
                          : Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              padding: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                                color: Colors.black,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                "${"${AppLocalizations.of(context)!.translate('totalPrice')}"} : ${totalPrice ?? 0}",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      productModelList == null || productModelList.isEmpty
                          ? Container()
                          : GetProducts.offerDialogAr!.isEmpty
                              ? Container()
                              : Padding(padding: EdgeInsets.only(top: 20)),
                      productModelList == null || productModelList.isEmpty
                          ? Container()
                          : InkWell(
                              onTap: () async {
                                await checkToken();
                                if (token!.isNotEmpty) {
                                  await getCartProducts();
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => CartScreen(
                                      shifts: widget.shifts,
                                      id: widget.categoryId,
                                      name: widget.categoryName,
                                    ),
                                  ));
                                } else {
                                  _showMyDialog();
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.5,
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Colors.green,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "${AppLocalizations.of(context)!.translate('buy')}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                      Padding(padding: EdgeInsets.only(top: 20)),
                      cartError
                          ? Text(
                              "من فضلك اضف منج الى السله",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      isLoadingMoreData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : Container(),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  SendMessageScreen(id: widget.categoryId),
                            ));
                          },
                          child: Text(
                              "${AppLocalizations.of(context)!.translate('sendcomplainMsg')}")),
                      Padding(padding: EdgeInsets.only(top: 40)),
                    ],
                  ),
                ),
              ));
  }
}
