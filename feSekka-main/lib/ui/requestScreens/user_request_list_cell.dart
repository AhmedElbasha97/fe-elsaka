import 'package:FeSekka/ui/requestScreens/user_request_detailed_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../model/user_request_list_model.dart';

class CarListWidget extends StatelessWidget {
  const CarListWidget({ required this.carData});
  final UserRequestListModel carData;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserRequestDetailedScreen(carData: carData,),
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            width:  MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.3,
            decoration: BoxDecoration(
              color: Color(0xFF66a5b4),
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Center(
              child: Stack(

                children: [

                  Positioned(
                    bottom: 0,
                    child: Container(
                      width:  MediaQuery.of(context).size.width*0.9,
                      height: MediaQuery.of(context).size.height*0.26,
                      decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                        border: Border.all(color: Color(0xFF66a5b4),width: 3),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width*0.55,
                            height: MediaQuery.of(context).size.height*0.24,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 3.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Type of car:":"نوع السياة:",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${Localizations.localeOf(context).languageCode == "en" ?carData.brandNameEn:carData.brandNameAr}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"car model:":"موديل السياة:",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${Localizations.localeOf(context).languageCode == "en" ?carData.modelNameEn:carData.modelNameAr}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Year of car manufacture:":"سنه تصنيع السيارة:",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${carData.year}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Type of Request:":"نوع الطلب:",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${carData.type}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Country :":"البلد :",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${Localizations.localeOf(context).languageCode == "en" ?carData.countryNameEn:carData.countryNameAr}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Section  :":"القسم  :",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${Localizations.localeOf(context).languageCode == "en" ?carData.mainCategoryNameEn:carData.mainCategoryNameAr}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Time to create the order:":"وقت انشاء الطلب :",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${carData.created}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Spare parts type:":"نوع القطعه الغيار:",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${Localizations.localeOf(context).languageCode == "en" ?carData.partlNameEn:carData.partNameAr}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        Localizations.localeOf(context).languageCode == "en" ?"Spare parts condition:":"حاله قطعه الغيار:",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Color(0xFF66a5b4),
                                          fontWeight: FontWeight.w900,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),

                                      ),
                                      Text(
                                        "${carData.isNew == "1"?"جديده":"أستعمال"}",
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          letterSpacing: 0,

                                        ),),
                                    ],
                                  ),

                                ],
                              ),
                            ),

                          ),
                        ],
                      ),
                    ),
                  ),
                 Localizations.localeOf(context).languageCode == "en" ?Positioned(
                    right: 15,
                    top: 0,
                    child: Stack(
                      children: [
                        Container(
                          width:  MediaQuery.of(context).size.width*0.33,
                          height:  MediaQuery.of(context).size.height*0.18,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: MediaQuery.of(context).size.height * 0.145,
                            decoration:  BoxDecoration(
                              color: Color(0xFF66a5b4),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(48), // Image radius
                                  child:Container(
                                    width: MediaQuery.of(context).size.width * 0.28,
                                    height: MediaQuery.of(context).size.height * 0.145,
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        border: Border.all(color: Colors.black)),
                                    child: CachedNetworkImage(
                                      imageUrl: carData.picpath == null || carData.picpath!.isEmpty
                                          ? ""
                                          : carData.picpath??"",
                                      placeholder: (context, url) => SizedBox(
                                        width: MediaQuery.of(context).size.width * 0.25,
                                        height: MediaQuery.of(context).size.height * 0.1,
                                        child: FittedBox(
                                          fit: BoxFit.scaleDown,
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) => Icon(Icons.error),
                                      fit: BoxFit.fitHeight,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                          ),
                        ),

                      ],
                    ),
                  ):
                  Positioned(
                    left: 15,
                    top: 0,
                    child: Stack(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.28,
                          height: MediaQuery.of(context).size.height * 0.145,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.28,
                            height: MediaQuery.of(context).size.height * 0.145,
                            decoration:  BoxDecoration(
                              color: Color(0xFF66a5b4),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child:Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Image border
                                child: SizedBox.fromSize(
                                  size: Size.fromRadius(48), // Image radius
                                  child:Container(
                                    width: MediaQuery.of(context).size.width * 0.28,
                                    height: MediaQuery.of(context).size.height * 0.145,
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(8)),
                                        border: Border.all(color: Colors.white)),

                                    child: CachedNetworkImage(
                                      imageUrl: carData.picpath == null || carData.picpath!.isEmpty
                                          ? ""
                                          : carData.picpath??"",
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
                                ),
                              ),
                            ),

                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}