// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io';

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/main_model.dart';
import 'package:FeSekka/model/provider/subcategoryProvider.dart';
import 'package:FeSekka/services/get_categories.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/widgets/loader.dart';
import 'package:FeSekka/widgets/video_player_widget.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class AddProdcut extends StatefulWidget {
  @override
  _AddProdcutState createState() => _AddProdcutState();
}

class _AddProdcutState extends State<AddProdcut> {
  final picker = ImagePicker();
  ImageSource imgSrc = ImageSource.gallery;
  final ImagePicker _picker = ImagePicker();
  List<File> _images = [];
  bool isLoading = true;
  TextEditingController titleController = TextEditingController();
  TextEditingController titleEnController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController detailsEnController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController videoLinkController = TextEditingController();
  String chosenGarageValue = "";
  String chosenGarageTitle = "";
  String chosenProductTypeValue = "";
  String chosenProductTypeTitle = "";
  List<String> garageList = [
    "in","out","both","parts"
  ];
  List<String> itemTypeList= [
    "service","product "
  ];

  List<SubCategory> list = [];
  List<String?> mainCats = [];
  SubCategory? selectedCategory;
  List<MainCategory> catList = [];
  XFile? image;
   VideoPlayerController? _controller;
  late Future<void> _initializeVideoPlayerFuture;

   File? videoFile = File("");

  Future getVideo() async {
    Future<XFile?> _videoFile =
    ImagePicker().pickVideo(source: ImageSource.gallery);
    _videoFile.then((file) async {
      setState(() {
        videoFile = File(file?.path??"");
        _controller = VideoPlayerController.file(File(videoFile?.path??""));

        // Initialize the controller and store the Future for later use.
        _initializeVideoPlayerFuture = _controller!.initialize();

        // Use the controller to loop the video.
        _controller?.setLooping(true);
      });
    });
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller?.dispose();
    super.dispose();
  }
  getData() async {
    list = await ServiceProviderService().getSubcatogies();
    catList = await GetCategories().getMainCategory();
    isLoading = false;
    setState(() {});
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
  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    List<String> garageListTitle = [AppLocalizations.of(context)!.translate('garageTap1')!,AppLocalizations.of(context)!.translate('garageTap2')!,AppLocalizations.of(context)!.translate('garageTap3')!,AppLocalizations.of(context)!.translate('garageTap4')!];
    List<String> productTypeListTitle = [AppLocalizations.of(context)!.translate('productType1')!,AppLocalizations.of(context)!.translate('productType2')!];

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(0)),
                border: Border.all(color: Colors.white, width: 1),
                color: Colors.white),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 150, minHeight: 100.0),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () async {
                      bool? done = await selectImageSrc();
                      if (done??false) {
                       await getPhoto(index, imgSrc);
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
                          child: _images.asMap()[index] == null
                              ? Icon(
                                  Icons.camera_alt,
                                  size: 30,
                                )
                              : Image.file(_images[index]),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _controller == null?InkWell(onTap: () async {
            await getVideo();
          },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.3,
              margin: EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.all(Radius.circular(20)),
                  border: Border.all(color: Color(0xFFB9B9B9)),
                  color: Color(0xFFF3F3F3)),
              alignment: Alignment.center,
              child: Icon(
                Icons.video_camera_back_rounded,
                size: 30,
              ),

            ),
          ):VideoPlayerWidget(videoPlayerController: _controller!),

          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.green)),
                    hintText:
                        "${AppLocalizations.of(context)!.translate('title')}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: titleEnController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.green)),
                    hintText:
                        "${AppLocalizations.of(context)!.translate('titleEn')}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.green)),
                    hintText:
                        "${AppLocalizations.of(context)!.translate('price')}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: videoLinkController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF90caf9))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF90caf9))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.green)),
                    hintText:
                        "${AppLocalizations.of(context)!.translate('linkYoutube')}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: detailsController,
                minLines: 3,
                maxLines: 4,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.green)),
                    hintText:
                        "${AppLocalizations.of(context)!.translate('details')}"),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: detailsEnController,
                minLines: 3,
                maxLines: 4,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 15,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Color(0xFF66a5b4))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        borderSide: BorderSide(color: Colors.green)),
                    hintText:
                        "${AppLocalizations.of(context)!.translate('detailsEn')}"),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
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
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  showAdaptiveActionSheet(
                    context: context,
                    title: Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.translate('subCats')}",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    actions: list.map<BottomSheetAction>((SubCategory value) {
                      return BottomSheetAction(
                          title: Padding(
                            padding: const EdgeInsets.only(right: 10, left: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            selectedCategory = value;
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
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Color(0xFF66a5b4)),
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
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: PopupMenuButton<String>(
              itemBuilder: (context) =>
              [
                PopupMenuItem(
                  value:itemTypeList[0],
                  textStyle: TextStyle(
                      color:  Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  onTap: (){
                    chosenProductTypeTitle=productTypeListTitle[0];
                    chosenProductTypeValue=itemTypeList[0];
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
                              productTypeListTitle[0],
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
                  value:itemTypeList[1],
                  textStyle: TextStyle(
                      color:  Colors.grey[700],
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                  onTap: (){
                    chosenProductTypeTitle=productTypeListTitle[1];
                    chosenProductTypeValue=itemTypeList[1];
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
                              productTypeListTitle[1],
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
                        chosenProductTypeTitle==""?"${AppLocalizations.of(context)!.translate('productTypeTitle')}":chosenProductTypeTitle  ,
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
          SizedBox(
            height: 10,
          ),
          isLoading
              ? Loader()
              : InkWell(
                  onTap: () => addProducttoServer(),
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
                          "${AppLocalizations.of(context)!.translate('addProduct')}",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
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

  addProducttoServer() async {
    isLoading = true;
    setState(() {});
    await ServiceProviderService().addProduct(
        detailsController.text,
        detailsEnController.text,
        priceController.text,
        titleController.text,
        titleEnController.text,
        _images.isEmpty ? null : _images[0],
        _images.length < 2 ? null : _images[1],
        _images.length < 3 ? null : _images[2],
        _images.length < 4 ? null : _images[3],
        selectedCategory == null ? null : selectedCategory!.subcategoryId,
        mainCats.isEmpty == null ? null : mainCats,
        videoLinkController.text,
    chosenProductTypeValue,videoFile?.path.isEmpty??true ? null :videoFile,chosenGarageValue );
    isLoading = false;
    setState(() {});
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
