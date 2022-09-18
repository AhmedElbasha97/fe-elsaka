// ignore_for_file: deprecated_member_use, unused_field

import 'package:FeSekka/widgets/AppDrawer.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:FeSekka/services/get_photo_slider.dart';
import 'package:flutter/material.dart';
import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/main_model.dart';
import 'package:FeSekka/services/get_categories.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class MenOrWomen extends StatefulWidget {
  MenOrWomen();
  @override
  _MenOrWomenState createState() => _MenOrWomenState();
}

class _MenOrWomenState extends State<MenOrWomen> {
  List<MainCategory> list = [];
  late List imgList;
  List? child;
  int _current = 0;
  final CarouselController _controller = CarouselController();
  String? name;
  String? token;

  Future getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = prefs.getString('name') ??
        "${AppLocalizations.of(context)!.translate('newUser')}";
    token = prefs.getString('token') ?? "";
    return prefs;
  }

  getPhotoSlider() async {
    imgList = await GetPhotoSlider().getPhotoSlider();
  }

  List<T?> map<T>(List list, Function handler) {
    List<T?> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  photoSlider() async {
    await getPhotoSlider();
    print(imgList.first);
    child = map<Widget>(
      imgList,
      (index, i) {
        return Container(
          margin: EdgeInsets.all(5.0),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            child: CachedNetworkImage(
              imageUrl: i,
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
        );
      },
    ).toList();
  }

  bool isLoading = true;
  @override
  void initState() {
    super.initState();

    getMainCategories();
  }

  getMainCategories() async {
    await getUserData();
    list = await GetCategories().getMainCategory();
    await photoSlider();
    isLoading = false;
    setState(() {});
  }

  bool? isItMen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: isLoading ? Container() : AppDrawer(token, name),
      appBar: AppBar(
        backgroundColor: Color(0xFF66a5b4),
        title: Image.asset(
          "assets/icon/appBarLogo.png",
          scale: 30,
        ),
        centerTitle: true,
      ),
      body: isLoading
          ?  Loader()
          : list.isEmpty
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                        "${AppLocalizations.of(context)!.translate('noCats')}"),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                            setState(() {
                              _current = index;
                            });
                          },
                        ),
                      ),
                      AnimationLimiter(
                        child: ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 1500),
                                child: SlideAnimation(
                                    verticalOffset: 50.0,
                                    child: FadeInAnimation(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(
                                            builder: (context) => HomeScreen(
                                                id: list[index].mainCategoryId),
                                          ));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 5, horizontal: 5),
                                          child: CachedNetworkImage(
                                              imageUrl: Localizations.localeOf(
                                                              context)
                                                          .languageCode ==
                                                      "en"
                                                  ? "${list[index].picpathEn}"
                                                  : "${list[index].picpath}"),
                                        ),
                                      ),
                                    )));
                          },
                        ),
                      )
                    ],
                  ),
                ),
    );
  }
}
