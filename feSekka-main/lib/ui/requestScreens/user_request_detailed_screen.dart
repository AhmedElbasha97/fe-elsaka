
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../model/user_request_list_model.dart';
import '../../services/serviceProvider.dart';
import '../../widgets/loader.dart';
import 'message/message_list_screen.dart';

class UserRequestDetailedScreen extends StatelessWidget {

   UserRequestDetailedScreen({ required this.carData});
  final UserRequestListModel carData;
  bool isLoading = true;

  List<UserRequestListModel> data = [];

  String? token;

  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          "تفاصيل الطلب",
          style: TextStyle(color:Color(0xFF66a5b4,),
          fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color:Color(0xFF66a5b4),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        width:  MediaQuery.of(context).size.width,
        child: ListView(
          children: [
            Container(
              width: MediaQuery.of(context).size.width ,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration:  BoxDecoration(
                color: Color(0xFF66a5b4),

              ),
              child:Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8), // Image border
                  child: SizedBox.fromSize(
                    size: Size.fromRadius(48), // Image radius
                    child:Container(
                      width: MediaQuery.of(context).size.width ,
                      height: MediaQuery.of(context).size.height * 0.4,
                      padding: EdgeInsets.all(2),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          border: Border.all(color: Colors.white)),

                      child: CachedNetworkImage(
                        imageUrl: carData.picpath == null || carData.picpath!.isEmpty
                            ? ""
                            : carData.picpath??"",
                        placeholder: (context, url) => SizedBox(
                          width: MediaQuery.of(context).size.width ,
                          height: MediaQuery.of(context).size.height * 0.4,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                children: [
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Type of car:":"نوع السياة:",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${Localizations.localeOf(context).languageCode == "en" ?carData.brandNameEn:carData.brandNameAr}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"car model:":"موديل السياة:",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${Localizations.localeOf(context).languageCode == "en" ?carData.modelNameEn:carData.modelNameAr}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Year of car manufacture:":"سنه تصنيع السيارة:",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${carData.year}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Type of Request:":"نوع الطلب:",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${carData.type}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Country :":"البلد :",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${Localizations.localeOf(context).languageCode == "en" ?carData.countryNameEn:carData.countryNameAr}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Section  :":"القسم  :",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${Localizations.localeOf(context).languageCode == "en" ?carData.mainCategoryNameEn:carData.mainCategoryNameAr}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Time to create the order:":"وقت انشاء الطلب :",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${carData.created}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Spare parts type:":"نوع القطعه الغيار:",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${Localizations.localeOf(context).languageCode == "en" ?carData.partlNameEn:carData.partNameAr}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),

                  Row(
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"Spare parts condition:":"حاله قطعه الغيار:",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Text(
                        "${carData.isNew == "1"?"جديده":"أستعمال"}",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),),
                    ],
                  ),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text(
                        Localizations.localeOf(context).languageCode == "en" ?"details :":
                        "التفاصيل:",
                        textAlign: TextAlign.center,
                        style:  TextStyle(
                          color: Color(0xFF66a5b4),
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                          letterSpacing: 0,

                        ),

                      ),
                      Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.9,

                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(8)),
                              border: Border.all(color: Color(0xFF66a5b4),)),
                          child: Text(
                            "${carData.message}",
                            textAlign: TextAlign.center,
                            style:  TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              letterSpacing: 0,

                            ),),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            carData.unreadMessages==0?Text(
              Localizations.localeOf(context).languageCode == "en" ?"Your application has not been accepted yet":"لم يتم قبول طلبك حتى الأن",
              textAlign: TextAlign.center,
              style:  TextStyle(
                color: Color(0xFF66a5b4),
                fontWeight: FontWeight.w900,
                fontSize: 20,
                letterSpacing: 0,

              ),

            ):InkWell(
              onTap: (){
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MessageListScreen( orderId: carData.orderId,),
                ));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFF66a5b4),
                  ),
                  child: Text(
                      Localizations.localeOf(context).languageCode == "en" ?"Show garages that accepted the request":"أظهار الجراجات التى قبلت الطلب",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
            SizedBox(height: 20,),
            InkWell(
              onTap: (){
                ServiceProviderService().addRequest(carData.message??"",  null , [carData.mainCategoryId],  carData.type??"", [carData.orderId??""],carData.isNew??"",carData.partId??"",carData.brandId??"",carData.countryId??"",[carData.modelId??""],[carData.yearId??""] );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color: Color(0xFF66a5b4),
                  ),
                  child: Text(
                      Localizations.localeOf(context).languageCode == "en" ?"Request again":"أعاده الطلب مره أخرى",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            )
          ],
        )
      ),
    );
  }
}