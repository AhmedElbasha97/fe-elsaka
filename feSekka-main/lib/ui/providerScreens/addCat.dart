import 'dart:async';
import 'dart:io';

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddCatogoryPage extends StatefulWidget {
  @override
  _AddCatogoryPageState createState() => _AddCatogoryPageState();
}

class _AddCatogoryPageState extends State<AddCatogoryPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController titleEnController = TextEditingController();
  final picker = ImagePicker();
  ImageSource imgSrc = ImageSource.gallery;
  PickedFile? img;
  bool isLoading = false;
  final ImagePicker _picker = ImagePicker();
  Future<void> getImageFromUserThroughCamera() async {
    XFile? image = await _picker.pickImage(source: ImageSource.camera);
    img = PickedFile(image!.path);
  }

  //get image from user through gallery
  Future<void> getImageFromUserThroughGallery() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    img = PickedFile(image!.path);
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
                bool? done = await selectImageSrc() ;
                if (done??false) {
                if(imgSrc == ImageSource.camera) {
                await getImageFromUserThroughCamera();
                setState(() {
                });
                }else{
                await getImageFromUserThroughGallery();
                setState(() {
                });
                }

                }
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
          SizedBox(
            height: 10,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : InkWell(
                  onTap: () => addCat(),
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
                          "${AppLocalizations.of(context)!.translate('addSubCat')}",
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

  addCat() async {
    isLoading = true;
    setState(() {});
    await ServiceProviderService().addSubCatogry(
      titleController.text,
      titleEnController.text,
      img == null ? null : File(img!.path),
    );
    isLoading = false;
    setState(() {});
    Navigator.of(context).pop(true);
    Navigator.of(context).pop(true);
  }
}
