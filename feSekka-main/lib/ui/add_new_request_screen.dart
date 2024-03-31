import 'dart:io';

import 'package:FeSekka/model/car_part_model.dart';
import 'package:FeSekka/model/provider/subcategoryProvider.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../I10n/app_localizations.dart';
import '../model/car_brand_model.dart';
import '../model/car_category_mmodel.dart';
import '../model/car_year_model.dart';
import '../model/main_model.dart';
import '../model/message_response_model.dart';
import '../model/zones_model.dart';
import '../services/appInfo.dart';
import '../services/get_categories.dart';
import '../services/serviceProvider.dart';
import 'men_or_women.dart';

class AddNewRequestScreen extends StatefulWidget {
  const AddNewRequestScreen({key});

  @override
  State<AddNewRequestScreen> createState() => _AddNewRequestScreenState();
}

class _AddNewRequestScreenState extends State<AddNewRequestScreen> {
  final picker = ImagePicker();
  bool loading = false;

  ImageSource imgSrc = ImageSource.gallery;
  final ImagePicker _picker = ImagePicker();
  List<String> chosenZoneId = ["all"];
  List<ZonesModel>? zones = [];
  List<File> _images = [];
  XFile? image;
  String chosenGarageTitle = "";
  String chosenProductTypeValue = "service";
  TextEditingController titleController = TextEditingController();
  String chosenProductTypeTitle = "";
  List<CarPartModel>? carParts = [];
  List<CarBrandModel>? carBrandS = [];
  List<CarYearModel>? carYears = [];
  List<CarCategoryModel>? carCategories = [];
  List<String> garageList = [
    "in","out","all","parts"
  ];
  List<String> itemTypeList= [
    "service","product "
  ];
  String chosenPartStatus = "1";
  String chosenPartTypeId = "";
  String chosenPartTypeTitle = "";
  String chosenCarTypeId = "";
  String chosenCarTypeTitle = "";
  String chosenCarYearsId = "";
  List<String> chosenCarYearsTitle = [];
  String chosenCarCategoriesId = "";
  List<String> chosenCarCategoriesTitle = [];
  List<SubCategory> list = [];
  List<String?> mainCats = [];
  SubCategory? selectedCategory;
  List<MainCategory> catList = [];


  List<String> chosenGarageValue = [];
  bool isLoading = true;
  @override
void initState() {
  super.initState();
  getData();
}
  getData() async {
    list = await ServiceProviderService().getSubcatogies();
    catList = await GetCategories().getMainCategory();
    carParts = await AppInfoService().getCarsPartType();
    carBrandS  = await AppInfoService().getCarsBrands();
    carYears = await AppInfoService().getCarsYears();
    zones = await AppInfoService().getZones();

    isLoading = false;
    setState(() {});
  }
  getCarsCategories(String id) async {
    carCategories = await AppInfoService().getCarsCategories(id);
    setState(() {

    });
  }
  String? massageValidator( String? value){

    if (value!.length < 2||value.isEmpty) {
      return "الرسالة مطلوبة";
    }
    return null;

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
  Widget build(BuildContext context) {
    List<String> garageListTitle = [AppLocalizations.of(context)!.translate('garageTap1')!,AppLocalizations.of(context)!.translate('garageTap2')!,AppLocalizations.of(context)!.translate('garageTap3')!,AppLocalizations.of(context)!.translate('garageTap4')!];
    List<String> productTypeListTitle = [AppLocalizations.of(context)!.translate('productType1')!,AppLocalizations.of(context)!.translate('productType2')!];

    return Scaffold(
      appBar: AppBar(),
    body: isLoading?Loader():ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            AppLocalizations.of(context)!.translate( "add photos")??"",
            style: TextStyle(
                color:  Colors.grey[700],
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
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
                child: _images.asMap()[0] == null
                    ? Icon(
                  Icons.camera_alt,
                  size: 30,
                )
                    : Image.file(_images[0]),
              )
            ],
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
                        "${AppLocalizations.of(context)!.translate('selecteCat')}",
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
                  height: 45,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Color(0xFF90caf9)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          selectedCategory == null
                              ? "${AppLocalizations.of(context)!.translate('selecteCat')}"
                              : Localizations.localeOf(context).languageCode ==
                              "en"
                              ? "${selectedCategory!.titleen}"
                              : "${selectedCategory!.titlear}",
                          style:
                          TextStyle(color: Colors.grey[600], fontSize: 20),
                          textAlign: TextAlign.start,
                        ),
                        Container(
                          width: 50,
                          height: 50,
                          child: CachedNetworkImage(
                              imageUrl: selectedCategory == null
                                  ? ""
                                  : "${selectedCategory!.image}"),
                        )
                      ],
                    ),
                  ),
                )),
          ),
          Text(
            "${AppLocalizations.of(context)!.translate('productTypeTitle')}"??"",
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
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: (){
                        chosenProductTypeValue=itemTypeList[0];
                        setState(() {

                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          chosenProductTypeValue==itemTypeList[0]?Container(
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
                            productTypeListTitle[0],
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
                        chosenProductTypeValue=itemTypeList[1];
                        setState(() {

                        });
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          chosenProductTypeValue==itemTypeList[1]?Container(
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
                            productTypeListTitle[1],
                            style: TextStyle(
                                color:  Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
          ),
          SizedBox(
            height: 10,
          ),
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


                    if( chosenGarageValue.contains(garageList[0])){
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
                            chosenGarageValue.contains(garageList[0])?Container(
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
                    if( chosenGarageValue.contains(garageList[1])){
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
                            chosenGarageValue.contains(garageList[1])?Container(
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

                    if( chosenGarageValue.contains(garageList[2])){
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
                            chosenGarageValue.contains(garageList[2])?Container(
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
                    if( chosenGarageValue.contains(garageList[3])){
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
                            chosenGarageValue.contains(garageList[3])?Container(
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
          SizedBox(
            height: 10,
          ),
          chosenGarageValue.contains(garageList[3])?Container(
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
          chosenGarageValue.contains(garageList[3])?Container(
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
                            value:e?.partsId,
                            textStyle: TextStyle(
                                color:  Colors.grey[700],
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                            onTap: (){
                              chosenPartTypeTitle= '${Localizations.localeOf(context).languageCode == "en" ?e.titleEn:e.titleAr}';
                              chosenPartTypeId = e?.partsId??"";
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
          chosenGarageValue.contains(garageList[3])?Container(
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
          chosenGarageValue.contains(garageList[3])&&(carCategories?.isNotEmpty??false)?Container(
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
                              chosenCarCategoriesId = e.modelId??"";


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
                                       chosenCarCategoriesId==e.modelId?Container(
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
          chosenGarageValue.contains(garageList[3])&&carCategories!=[]?Container(
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
                              chosenCarYearsId=e.yearId??"";
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
                                      chosenCarYearsId==e.yearId?Container(
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
          const SizedBox(
            height: 15,
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
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
                validator:massageValidator,
                controller:titleController,
                maxLines: 4,
                textAlign: TextAlign.right,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context)!.translate('typeMsg'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Color(0xFF66a5b4))),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Color(0xFF66a5b4))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide(color: Colors.green)),
                )),
          ),
          const SizedBox(
            height: 15,
          ),
          loading? Center(child: CircularProgressIndicator(color: Color(0xFF66a5b4),)): InkWell(
            onTap: () async {
              loading = true;
              setState(() {});
              MessageResponseModel? data = await ServiceProviderService().addRequest(titleController.text, _images.isEmpty ? null : _images[0], mainCats,  chosenProductTypeValue, chosenGarageValue,chosenPartStatus,chosenPartTypeId==""?"0":chosenPartTypeId,chosenCarTypeId==""?"0":chosenCarTypeId,chosenZoneId[0],chosenCarCategoriesId==""?["0"]:[chosenCarCategoriesId],chosenCarYearsId==""?["0"]:[chosenCarYearsId] );
              if(data?.status??false) {
                loading = false;
                setState(() {});
                final snackBar = SnackBar(content:
                Row(children: [
                  Icon(Icons.check,color: Colors.white,),
                  SizedBox(width: 10,),
                  Text(Localizations.localeOf(context).languageCode == "en" ?'The request was created successfully':'تم أنشاء الطلب بنجاح',style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                ],),
                    backgroundColor:Colors.green
                );

                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MenOrWomen(),
                ));
              }else{
                loading = false;
                setState(() {});
                final snackBar = SnackBar(content:
                Row(children: [
                  Icon(Icons.close,color: Colors.white,),
                  SizedBox(width: 10,),
                  Text(Localizations.localeOf(context).languageCode == "en" ?'Try creating the order again':'حاول أنشاء الطلب مره اخرى',style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold
                  ),
                  ),
                ],),
                    backgroundColor:Colors.red
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
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
                    Localizations.localeOf(context).languageCode == "en" ?"Create an order":"أنشاء طلب",
                    style: TextStyle(color: Colors.white)),
              ),
            ),
          )
        ],
      ),
    );
  }
}

