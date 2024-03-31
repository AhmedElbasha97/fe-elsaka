// ignore_for_file: must_be_immutable, deprecated_member_use

import 'dart:async';
import 'package:FeSekka/model/car_brand_model.dart';
import 'package:FeSekka/model/car_category_mmodel.dart';
import 'package:FeSekka/model/car_part_model.dart';
import 'package:FeSekka/model/car_year_model.dart';
import 'package:FeSekka/model/zones_model.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:FeSekka/ui/cart_screen.dart';
import 'package:FeSekka/ui/logIn_screen.dart';
import 'package:FeSekka/ui/signUp_screen.dart';
import 'package:FeSekka/widgets/product_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/category.dart';
import 'package:FeSekka/model/product.dart';
import 'package:FeSekka/services/cart_services.dart';
import 'package:FeSekka/services/get_all_products.dart';
import 'package:FeSekka/services/get_categories.dart';
import 'package:FeSekka/ui/products_screen.dart';
import 'package:FeSekka/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:star_rating/star_rating.dart';
import '../model/courser_model.dart';
import '../model/main_model.dart';
import '../widgets/loader.dart';

class HomeScreen extends StatefulWidget {
  String? id;
  HomeScreen({this.id});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  List<MainCategory>list =[] ;
  String selectedCategory = "";
  List<Widget> dotsList = [];
  bool isLoadingMoreData = false;
  bool isSearchClicked = false;
  bool isLoadingProducts = false;
  bool isFilterShowed = false;
  final CarouselController _controller = CarouselController();
  int _current = 0;
  int apiPage = 1;
  int totalProductsInCart = 0;
  bool isCategoryOn = false;

  List? child;
  List? photoSliderList;
  List<CategoryModel> categoryModelList = <CategoryModel>[];
  List<ProductModel> productModelList = <ProductModel>[];
  List<String> cart = <String>[];
  late LatLng position;
  String? name;
  String? token;

  List<String> garageList = [
  "all","out","in","parts"
  ];
  List<String> chosenGarageValue = ["all"];
  String chosenGarageTitle = "";
  ScrollController? _loadMoreDataController;
  bool isLocationActive = false;
  FocusNode searchFocusNode = FocusNode();
  TextEditingController searchController = TextEditingController();
  List<CarPartModel>? carParts = [];
  List<CarBrandModel>? carBrandS = [];
  List<CarYearModel>? carYears = [];
  List<CarCategoryModel>? carCategories = [];
  List<String> chosenZoneId = ["all"];
  List<ZonesModel>? zones = [];
  List<CourserModel>? sliderPhotos = [];
  String chosenPartStatus = "0";
  String chosenPartTypeId = "0";
  String chosenPartTypeTitle = "";
  String chosenCarTypeId = "0";
  String chosenCarTypeTitle = "";
  String chosenCarYearsId ="0";
  List<String> chosenCarYearsTitle = [];
  String chosenCarCategoriesId = "0";
  List<String> chosenCarCategoriesTitle = [];
  getCarsCategories(String id) async {
    carCategories = await AppInfoService().getCarsCategories(id);
    setState(() {

    });
  }
  getMainCategories() async {
    carParts = await AppInfoService().getCarsPartType();
    carBrandS  = await AppInfoService().getCarsBrands();
    carYears = await AppInfoService().getCarsYears();
    zones = await AppInfoService().getZones();
    list = await GetCategories().getMainCategory();
    list.forEach( (data) {
      if(data.mainCategoryId == widget.id){
        selectedCategory = (Localizations.localeOf(
            context)
            .languageCode ==
            "en"
            ?data.titleen:data.titlear)!;
        list.remove(data);
      }

    });

  }
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('تسجيل الدخول'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('قم بتسجيل الدخول لتتمكن من إتمام عملية الشراء.'),
              ],
            ),
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => LogInScreen(
                      isCheck: false,
                    ),
                  ));
                },
              ),
            ),
            Center(
              child: TextButton(
                child: Text('مستخدم جديد',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SignUpScreen(
                      isCheck: false,
                    ),
                  ));
                },
              ),
            ),
            Center(
              child: TextButton(
                child:
                    Text('رجوع', style: TextStyle(fontWeight: FontWeight.bold)),
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

  getTotalNumberProductsInCart() async {
    await CartServices().viewCart(false);
    totalProductsInCart = CartServices.totalQuantity ?? 0;
    if (mounted) setState(() {});
  }


  getCategoriesByLocation(double lat, double long) async {
    categoryModelList.clear();
    categoryModelList =
        await GetCategories().getCategoryByLocation(lat, long, widget.id);
    isLoading = false;
    setState(() {});
  }

  getLocation() async {
    Position res = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      position = LatLng(
          res.latitude,res.longitude
      );

    });
    await getCategoriesByLocation(position.latitude, position.longitude);
  }

  getCategories() async {
    isLoading = true;
    setState(() {

    });
    categoryModelList = await GetCategories().getCategory(widget.id,chosenGarageValue,chosenZoneId );
    print(categoryModelList.length);
    isLoading = false;
    setState(() {});
  }
  clearFilters(){
  chosenGarageValue = ["all"];
  chosenZoneId = ["all"];
  chosenCarTypeId="";
  chosenCarYearsId ="0";
  chosenCarTypeId = "0";
  chosenPartStatus = "0";
  chosenPartTypeId = "0";
  if(isCategoryOn){
    getCategories();
  }else{
    getAllProducts();
  }

  setState(() {

  });
}

  startFiltering(){
      if(isCategoryOn){
        getCategories();
      }else{
        getAllProducts();
      }
  }
  searchCategories() async {
    isLoading = true;
    setState(() {});
    categoryModelList =
        await GetCategories().searchCategory(searchController.text,chosenGarageValue,chosenZoneId,chosenPartStatus,chosenPartTypeId,chosenCarTypeId,chosenCarCategoriesId,chosenCarYearsId) ;
    isLoading = false;
    setState(() {});
  }

  getAllProducts() async {

    isLoadingProducts = true;
    setState(() {});
     getMainCategories();
    productModelList.clear();
    productModelList =
        await (GetAllProducts().getProductsbyCategory(apiPage, token, widget.id,chosenGarageValue,chosenZoneId,chosenPartStatus,chosenPartTypeId,chosenCarTypeId,chosenCarCategoriesId,chosenCarYearsId) );
    print('******************************************');
    print(token);
    print('---');
    for (int i = 0; i < productModelList.length; i++) {
      print(i);
      print(productModelList[i].quantity);
      print(productModelList[i].provider?.whatsapp??"");
      print(productModelList[i].shareurl??"");
      print('--------');
    }
    print('******************************************');
    isLoadingProducts = false;
    setState(() {});
  }

  getMoreData() async {
    print(apiPage);
    if (apiPage != 0) {
      isLoadingMoreData = true;
      setState(() {});
      print(apiPage);
      apiPage++;
      print(apiPage);
      List<ProductModel>? productModelList = <ProductModel>[];
      productModelList = await (GetAllProducts()
          .getProductsbyCategory(apiPage, token, widget.id,chosenGarageValue,chosenZoneId,chosenPartStatus,chosenPartTypeId,chosenCarTypeId,chosenCarCategoriesId,chosenCarYearsId) );
      if (productModelList!.isNotEmpty) {
        this.productModelList.addAll(productModelList);
      } else
        apiPage--;
      isLoadingMoreData = false;
      setState(() {});
    }
  }

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ??
        "${AppLocalizations.of(context)!.translate('newUser')}";
    token = prefs.getString('token') ?? "";
    return prefs;
  }

  @override
  void initState() {
    super.initState();
    getTotalNumberProductsInCart();
    _loadMoreDataController = new ScrollController();
    _loadMoreDataController!.addListener(() async {
      if (_loadMoreDataController!.position.pixels ==
          _loadMoreDataController!.position.maxScrollExtent) {
        getMoreData();
      }
    });
    photoSlider();
  }

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  getPhotoSlider() async {
    sliderPhotos = await AppInfoService().getSlider();
    setState(() {

    });
  }
  makingDotsForCarouselSlider(int activeIndex){
    int productLength = sliderPhotos?.length??0;
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
  photoSlider() async {

    await getPhotoSlider();
    await getUserData();
    await getAllProducts();
    await getCategories();

    makingDotsForCarouselSlider(0);
    print("hiiiiiiiiiiiiiiiii ${sliderPhotos?[0].toString()}");
    child = map<Widget>(
      sliderPhotos!,
      (index, CourserModel i) {
        return  InkWell(
            onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
            builder: (context) =>ProductsScreen(
            i.providerId,
            Localizations
                .localeOf(
                context)
                .languageCode ==
                "en"
                ? i.titleEn
                : i.titleAr,
            i
                .sub,
            Localizations.localeOf(
                context)
                .languageCode ==
                "en"
                ? "en"
                : "ar",
                i
                .wrokHours,
            i.lat,
            i
                .long,
            i
                .whatsapp,
            i
                .mobile,
            i
                .rate,
                i
                .slider)));},
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(5.0)),
              child: CachedNetworkImage(
                imageUrl:i.picpathEn ??"",
                fit: BoxFit.cover,
                width: 1000.0,
                placeholder: (context, url) => SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).toList();

    getCategories();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> garageListTitle = [AppLocalizations.of(context)!.translate('garageTap1')!,AppLocalizations.of(context)!.translate('garageTap2')!,AppLocalizations.of(context)!.translate('garageTap3')!,AppLocalizations.of(context)!.translate('garageTap4')!];

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xFF66a5b4),
        iconTheme: new IconThemeData(color: Colors.white),
        title: Image.asset(
          "assets/icon/appBarLogo.png",
          scale: 30,
        ),
        actions: [
          isCategoryOn
              ? Container()
              : InkWell(
                  onTap: () {
                    token!.isEmpty
                        ? _showMyDialog()
                        : Navigator.of(context)
                            .push(MaterialPageRoute(
                            builder: (context) => CartScreen(),
                          ))
                            .whenComplete(() {
                            getTotalNumberProductsInCart();
                            getAllProducts();
                            setState(() {});
                          });
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
                      Icon(Icons.shopping_cart),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                    ],
                  ),
                ),
          isCategoryOn
              ? InkWell(
            onTap:  () {
              isLocationActive = !isLocationActive;
              if (isLocationActive) {
                isLoading = true;
                setState(() {});
                getLocation();
              } else {
                getCategories();
              }
              setState(() {});
            },
            child: Image.asset(
              "assets/icon/Animation - 1702411739851 (1).gif",
              height: 40.0,
              width: 40.0,
            ),
          ) : Container(),
          isCategoryOn
              ? IconButton(
                  icon: Icon(
                    Icons.search,
                    color: isSearchClicked ? Colors.green : Colors.white,
                    size: 30,
                  ),
                  onPressed: () {
                    isSearchClicked = !isSearchClicked;
                    setState(() {});
                  },
                )
              : Container(),
        ],
        centerTitle: true,
      ),
      body: isLoading
          ?Loader()
          : SingleChildScrollView(
              controller: _loadMoreDataController,
              child: Column(
                children: <Widget>[
                  isSearchClicked
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: TextField(
                            controller: searchController,
                            focusNode: searchFocusNode,
                            textInputAction: TextInputAction.search,
                            onSubmitted: (value) {
                              searchCategories();
                            },
                            onChanged: (value) {
                              if (searchController.text.isEmpty) {
                                isLoading = true;
                                setState(() {});
                                getCategories();
                              }
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                disabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(color: Colors.grey)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    searchCategories();
                                  },
                                  icon: Icon(Icons.search, color: Colors.black),
                                ),
                                hintText: "search...",
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 1)),
                          ),
                        )
                      : Container(),
                  CarouselSlider.builder(
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
                        makingDotsForCarouselSlider(index);
                        setState(() {
                        });
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: dotsList,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PopupMenuButton<MainCategory>(
                      itemBuilder: (context) =>
                          list.map((e){
                            return   PopupMenuItem(
                              value:e,
                              textStyle: TextStyle(
                            color:  Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                              onTap: (){
                                Navigator.of(context)
                                    .push(MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                      id: e.mainCategoryId),
                                ));

                              },
                              child: SizedBox(
                                width:MediaQuery.of(context).size.width*0.9,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          (Localizations.localeOf(
                                              context)
                                              .languageCode ==
                                              "en"
                                              ?e.titleen:e.titlear)??"",
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
                                      height: 0.5,
                                      thickness: 0.5,
                                      endIndent: 0,
                                      indent: 0,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),

                      child: Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.9,
                          height: MediaQuery.of(context).size.height*0.07,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black,width: 0.5)
                          ),
                          child:   Center(
                            child:  Text(
                              "$selectedCategory" ,
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

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    child: Row(
                      children: [

                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              isCategoryOn = false;
                              isLoadingProducts = true;
                              apiPage = 1;
                              clearFilters();
                              getAllProducts();
                              setState(() {});
                            },
                            child: Container(
                                color: isCategoryOn
                                    ? Colors.white
                                    : Color(0xFF66a5b4),
                                alignment: Alignment.center,
                                child: Text(
                                  "${AppLocalizations.of(context)!.translate('products')}",
                                  style: TextStyle(
                                      color: isCategoryOn
                                          ? Colors.grey[700]
                                          : Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              productModelList.clear();
                              clearFilters();
                              setState(() {
                                isCategoryOn = true;
                              });
                            },
                            child: Container(
                                color: isCategoryOn
                                    ? Color(0xFF66a5b4)
                                    : Colors.white,
                                alignment: Alignment.center,
                                child: Text(
                                  "${AppLocalizations.of(context)!.translate('category')}",
                                  style: TextStyle(
                                      color: isCategoryOn
                                          ? Colors.white
                                          : Colors.grey[700],
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                )),
                          ),
                        ),
                        Expanded(
                          flex:0,
                          child: InkWell(
                            onTap: () {
                              if(isFilterShowed){
                                isFilterShowed = false;
                              }else{
                                isFilterShowed = true;
                              }
                              setState(() {

                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.15,
                                color:

                                isFilterShowed?Color(0xFF66a5b4):Colors.white,
                                alignment: Alignment.center,
                                child: isFilterShowed?Icon(Icons.close,color: Colors.white,size: 30):Icon(Icons.manage_search_rounded,color: Colors.black,size: 30,)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isFilterShowed ,
                      child: Column(
                    children: [
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
                                if(chosenGarageValue.contains( garageList[0])){
                                  chosenGarageValue.remove(garageList[0]);
                                }else{
                                  chosenGarageValue.add(garageList[0]);
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
                                        chosenGarageValue.contains( garageList[0])?Container(
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
                                      height: 0.5,
                                      thickness: 0.5,
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
                                if(chosenGarageValue.contains( garageList[1])){
                                  chosenGarageValue.remove(garageList[1]);
                                }else{
                                  chosenGarageValue.add(garageList[1]);
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
                                        chosenGarageValue.contains( garageList[1])?Container(
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
                                      height: 0.5,
                                      thickness: 0.5,
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
                                if(chosenGarageValue.contains( garageList[2])){
                                  chosenGarageValue.remove(garageList[2]);
                                }else{
                                  chosenGarageValue.add(garageList[2]);
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
                                        chosenGarageValue.contains( garageList[2])?Container(
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
                                      height: 0.5,
                                      thickness: 0.5,
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
                                if(chosenGarageValue.contains( garageList[3])){
                                  chosenGarageValue.remove(garageList[3]);
                                }else{
                                  chosenGarageValue.add(garageList[3]);
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
                                        chosenGarageValue.contains( garageList[3])?Container(
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
                                      height: 0.5,
                                      thickness: 0.5,
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
                                  border: Border.all(color: Colors.black,width: 0.5)
                              ),
                              child:   Center(
                                  child:  Text(
                                    "${AppLocalizations.of(context)!.translate('garageTap1')!}",
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
                                      if(chosenZoneId.length == 1){
                                        chosenZoneId.add("all");
                                      }
                                      chosenZoneId.remove(e.zoneId);

                                    }else{
                                      if(chosenZoneId.length == 1){
                                        chosenZoneId.remove("all");
                                      }
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
                                          height: 0.5,
                                          thickness: 0.5,
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
                                    "${AppLocalizations.of(context)!.translate('zoneTitle1')}" ,
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
                      !isCategoryOn&&chosenGarageValue.contains(garageList[3])?Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              "${AppLocalizations.of(context)!.translate('chooseStatusCarPart')}"??"",
                              style: TextStyle(
                                  color:  Colors.grey[700],
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 10,
                            ),

                            Padding(
                                padding:  EdgeInsets.symmetric(horizontal:  MediaQuery.of(context).size.width * 0.2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        chosenPartStatus="1";
                                        setState(() {

                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          chosenPartStatus=="1"?Container(
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
                                          Container(width: 10,),
                                          Text(
                                            "${AppLocalizations.of(context)!.translate('statusNew')}"??"",
                                            style: TextStyle(
                                                color:  Colors.grey[700],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        chosenPartStatus="0";
                                        setState(() {

                                        });
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          chosenPartStatus=="0"?Container(
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
                                          Container(width: 10,),
                                          Text(
                                            "${AppLocalizations.of(context)!.translate('statusUsed')}"??"",
                                            style: TextStyle(
                                                color:  Colors.grey[700],
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ):SizedBox(),
                      !isCategoryOn&&chosenGarageValue.contains(garageList[3])?Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PopupMenuButton<String>(
                                itemBuilder: (context) =>
                                    carParts!.map((e){
                                      return  PopupMenuItem(
                                        value:e.partsId,
                                        textStyle: TextStyle(
                                            color:  Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        onTap: (){
                                          chosenPartTypeTitle= '${Localizations.localeOf(context).languageCode == "en" ?e.titleEn:e.titleAr}';
                                          chosenPartTypeId = e.partsId??"";
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
                                                  chosenPartTypeId == e.partsId?Container(
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
                                                height: 0.5,
                                                thickness: 0.5,
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
                                          chosenPartTypeTitle==""?"${AppLocalizations.of(context)!.translate('chooseCarPartsTitle1')}":"${AppLocalizations.of(context)!.translate('chooseCarPartTitle2')} $chosenPartTypeTitle"  ,
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
                          ],
                        ),
                      ):SizedBox(),
                      !isCategoryOn?Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PopupMenuButton<String>(
                                itemBuilder: (context) =>
                                    carBrandS!.map((e){
                                      return  PopupMenuItem(
                                        value:e.brandId,
                                        textStyle: TextStyle(
                                            color:  Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        onTap: (){
                                          chosenCarTypeTitle= '${Localizations.localeOf(context).languageCode == "en" ?e.titleEn:e.titleAr}';
                                          chosenCarTypeId = e.brandId??"";
                                          getCarsCategories(e.brandId??"");
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
                                                  chosenCarTypeId == e.brandId?Container(
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
                                                height: 0.5,
                                                thickness: 0.5,
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
                                          chosenCarTypeId==""?"${AppLocalizations.of(context)!.translate('chooseCarBrandTitle1')}":"${AppLocalizations.of(context)!.translate('chooseCarBrandTitle2')} $chosenCarTypeTitle"  ,
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
                          ],
                        ),
                      ):SizedBox(),
                      !isCategoryOn&&(carCategories?.isNotEmpty??false)?Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PopupMenuButton<String>(
                                itemBuilder: (context) =>
                                    carCategories!.map((e){
                                      return  PopupMenuItem(
                                        value:e.modelId,
                                        textStyle: TextStyle(
                                            color:  Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        onTap: (){
                                          if(chosenCarCategoriesId == e.modelId){
                                            chosenCarCategoriesId = "" ;
                                          }else{
                                            chosenCarCategoriesId = e.modelId??"";
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
                                                  chosenCarCategoriesId == e.modelId?Container(
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
                                                height: 0.5,
                                                thickness: 0.5,
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
                                          "${AppLocalizations.of(context)!.translate('chooseCarCategoryTitle1')}"  ,
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
                          ],
                        ),
                      ):SizedBox(),
                      !isCategoryOn&&chosenGarageValue.contains(garageList[3])&&carCategories!=[]?Container(
                        width: MediaQuery.of(context).size.width * 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: PopupMenuButton<String>(
                                itemBuilder: (context) =>
                                    carYears!.map((e){
                                      return  PopupMenuItem(
                                        value:e.yearId,
                                        textStyle: TextStyle(
                                            color:  Colors.grey[700],
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                        onTap: (){
                                          if(chosenCarYearsId==e.yearId){
                                            chosenCarYearsId = "";
                                          }else{
                                            chosenCarYearsId = e.yearId??"";
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
                                                  chosenCarYearsId.contains(e.yearId??"")?Container(
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
                                                    e.year??"",
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
                                                height: 0.5,
                                                thickness: 0.5,
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
                                          "${AppLocalizations.of(context)!.translate('chooseCarYearTitle')}"  ,
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
                          ],
                        ),
                      ):SizedBox(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              startFiltering();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Color(0xFF66a5b4),
                                ),
                                child: Text(
                                    "${AppLocalizations.of(context)!.translate('startFilterTitle')}",
                                    style: TextStyle(color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold
                                    ),),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              clearFilters();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  color: Color(0xFF66a5b4),
                                ),
                                child: Text(
                                    "${AppLocalizations.of(context)!.translate('clearFilter')}",
                                    style: TextStyle(color: Colors.white,fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  )),
                  isCategoryOn
                      ? categoryModelList.isEmpty
                          ? Center(
                              child: Text(
                                  "${AppLocalizations.of(context)!.translate('noCats')}"),
                            )
                          : GridView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: categoryModelList.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 10,
                                                vertical: 10),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Color(0xffbad4d9),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () =>
                                                        Navigator.of(context)
                                                            .push(MaterialPageRoute(
                                                      builder: (context) => ProductsScreen(
                                                          categoryModelList[index]
                                                              .id,
                                                          Localizations
                                                                          .localeOf(
                                                                              context)
                                                                      .languageCode ==
                                                                  "en"
                                                              ? categoryModelList[index]
                                                                  .titleEn
                                                              : categoryModelList[
                                                                      index]
                                                                  .titleAr,
                                                          categoryModelList[index]
                                                              .sub,
                                                          Localizations.localeOf(
                                                                          context)
                                                                      .languageCode ==
                                                                  "en"
                                                              ? "en"
                                                              : "ar",
                                                          categoryModelList[index]
                                                              .wrokHours,
                                                          categoryModelList[index]
                                                              .lat,
                                                          categoryModelList[index]
                                                              .long,
                                                          categoryModelList[index]
                                                              .whatsapp,
                                                          categoryModelList[index]
                                                              .mobile,
                                                          categoryModelList[index]
                                                              .rate,
                                                          categoryModelList[index]
                                                              .photos),

                                                    ))
                                                            .whenComplete(() async {
                                                      await getTotalNumberProductsInCart();
                                                    }),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(topLeft:
                                                              Radius.circular(
                                                                  10.0),topRight: Radius.circular(
                                                              10.0)),
                                                      child: HomeCard(

                                                        subCategory:
                                                            categoryModelList[
                                                                    index]
                                                                .sub,
                                                        title: Localizations
                                                                        .localeOf(
                                                                            context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? categoryModelList[
                                                                    index]
                                                                .titleEn
                                                            : categoryModelList[
                                                                    index]
                                                                .titleAr,
                                                        image: Localizations
                                                                        .localeOf(
                                                                            context)
                                                                    .languageCode ==
                                                                "en"
                                                            ? categoryModelList[
                                                                    index]
                                                                .picpathEn
                                                            : categoryModelList[
                                                                    index]
                                                                .picpath,
                                                        facebookUrl:
                                                            categoryModelList[
                                                                    index]
                                                                .facebook,
                                                        instagramUrl:
                                                            categoryModelList[
                                                                    index]
                                                                .insgram,
                                                        whatsappUrl:
                                                            categoryModelList[
                                                                    index]
                                                                .whatsapp,
                                                        snapChatUrl:
                                                            categoryModelList[
                                                                    index]
                                                                .snapchat,
                                                      ),
                                                    ),
                                                  ),

                                                  categoryModelList[index]
                                                      .rate==""?Container() :StarRating(
                                                    color: Colors.black,
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    length: 5,
                                                    rating: double.parse("${categoryModelList[index]
                                                        .rate}.0"??"0.0"),
                                                    between: 5,
                                                    starSize: 14,

                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                                    child: Text(
                                                        "${Localizations.localeOf(context).languageCode == 'en' ? categoryModelList[index].titleEn : categoryModelList[index].titleAr}",
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight: FontWeight.w600,

                                                        fontSize: 15),),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        )));
                              },
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: MediaQuery.of(context)
                                              .size
                                              .width /
                                          (MediaQuery.of(context).size.height*0.9 /
                                              1.7)),
                            )
                      : isLoadingProducts
                          ? Padding(
                              padding: EdgeInsets.only(top: 50),
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productModelList.length,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                    position: index,
                                    duration:
                                        const Duration(milliseconds: 1500),
                                    child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 5, horizontal: 5),
                                            child: LinearProductCard(
                                              providerNameAr: productModelList[index].provider?.titlear??"",
                                              providerNameEn: productModelList[index].provider?.titleen??"",
                                              phoneNumber: productModelList[index]
                                                  .provider!
                                                  .mobile,
                                              shareUrl:productModelList[index].shareurl??"" ,
                                              id: productModelList[index].id,
                                              providerId:
                                                  productModelList[index]
                                                      .provider!
                                                      .providerId,
                                              whatsappNumber:
                                                  productModelList[index]
                                                      .provider!
                                                      .whatsapp,
                                              titleEn: productModelList[index]
                                                  .titleEn,
                                              titleAr: productModelList[index]
                                                  .titleAr,
                                              detailsEn: productModelList[index]
                                                  .detailsEn,
                                              detailsAr: productModelList[index]
                                                  .detailsAr,
                                              price:
                                                  productModelList[index].price,
                                              video: productModelList[index]
                                                      .video ??
                                                  "",
                                              totalAmountInCart:
                                                  productModelList[index]
                                                      .quantity,
                                              salePrice: productModelList[index]
                                                  .salePrice,
                                              addItemToCart: () async {
                                                if (token == "") {
                                                  _showMyDialog();
                                                } else {
                                                  totalProductsInCart++;
                                                  setState(() {});
                                                }
                                              },
                                              removeItemFromCart: () async {
                                                if (token == "") {
                                                  _showMyDialog();
                                                } else {
                                                  totalProductsInCart--;
                                                  setState(() {});
                                                }
                                              },
                                              imgList: productModelList[index]
                                                  .images, type: productModelList[index].type??"",
                                            ),
                                          ),
                                        )));
                              },
                            ),
                ],
              ),
            ),
    );
  }
}
