import 'dart:async';
import 'dart:io';

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/spareParts/carModel.dart';
import 'package:FeSekka/model/spareParts/carYear.dart';
import 'package:FeSekka/model/spareParts/cartType.dart';
import 'package:FeSekka/model/spareParts/partQuailty.dart';
import 'package:FeSekka/model/spareParts/partType.dart';
import 'package:FeSekka/services/orderSparePartService.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RequestPartScreen extends StatefulWidget {
  @override
  _RequestPartScreenState createState() => _RequestPartScreenState();
}

class _RequestPartScreenState extends State<RequestPartScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  bool isLoading = true;
  bool modelLoading = false;

  List<CarType> types = [];
  List<CarModel> models = [];
  List<PartQuailty> quailty = [];
  List<CarYear> years = [];
  List<PartType> partTypes = [];

  final ImagePicker _picker = ImagePicker();

  CarType? selectedType;
  CarModel? selectedModel;
  PartQuailty? selectedpartQuailty;
  CarYear? selectedYear;
  PartType? selectedpartType;
  File? img;

  ImageSource imgSrc = ImageSource.gallery;
  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    getData();
  }
  Future<void> getImageFromUserThroughCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    img = File(image!.path);
  }

  //get image from user through gallery
  Future<void> getImageFromUserThroughGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    img = File(image!.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          SizedBox(
            height: 10,
          ),
          Center(
            child: InkWell(
              onTap: () async {
                bool? done = await selectImageSrc();
                if (done??false) {
                  if(imgSrc == ImageSource.camera) {
                   await getImageFromUserThroughCamera();
                   setState(() {
                   });
                  }else{
                   await getImageFromUserThroughGallery();
                   setState(() {
                     
                   });
                  }}
              },
              child: Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: Color(0xFFB9B9B9)),
                    color: Color(0xFFF3F3F3)),
                alignment: Alignment.center,
                child: img == null
                    ? Icon(
                        Icons.camera_alt,
                        size: 30,
                      )
                    : Image.file(File(img!.path)),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextField(
              controller: nameController,
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
                      "${AppLocalizations.of(context)!.translate('name')}"),
            ),
          ),
          SizedBox(
            height: 10,
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
        ],
      ),
    );
  }

  getData() async {
    types = await OrderSparepartService().getTypes();
    quailty = await OrderSparepartService().getPartQuailty();
    years = await OrderSparepartService().getYears();
    quailty = await OrderSparepartService().getPartQuailty();
    isLoading = false;
    setState(() {});
  }

  getModel(String id) async {
    modelLoading = true;
    setState(() {});
    models = await OrderSparepartService().getModels(id);
    modelLoading = false;
    setState(() {});
  }

  sendRequest() async {
    isLoading = true;
    setState(() {});
    await OrderSparepartService().orderPart(
        name: nameController.text,
        img: img,
        details: detailsController.text,
        carModel: selectedModel == null ? null : selectedModel!.carsModelsId,
        carYear: selectedYear == null ? null : selectedYear!.carsYearsId,
        carType: selectedType == null ? null : selectedType!.carsTypesId,
        partQuailty: selectedpartQuailty == null
            ? null
            : selectedpartQuailty!.carsPartsQualityId,
        partType: selectedpartType == null
            ? null
            : selectedpartType!.carsPartsTypesId);
    isLoading = false;
    setState(() {});
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
}
