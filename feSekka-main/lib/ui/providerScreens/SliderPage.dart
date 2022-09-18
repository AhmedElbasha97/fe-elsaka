import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/provider/sliderImg.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;

class SliderScreen extends StatefulWidget {
  @override
  _SliderScreenState createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  bool loading = true;
  final picker = ImagePicker();
  ImageSource imgSrc = ImageSource.gallery;

  List<SliderImage> data = [];
  PickedFile? pickedFile;

  @override
  void initState() {
    super.initState();
    getSilder();
  }

  getSilder() async {
    data = await ServiceProviderService().getSliderImgs();
    loading = false;
    setState(() {});
  }

  delete(imgId) async {
    loading = true;
    setState(() {});
    await ServiceProviderService().deleteSliderImgs(imgId);
    data.clear();
    getSilder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  selectImageSrc();
                },
                icon: Icon(Icons.add)),
          )
        ],
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.25,
                      margin: EdgeInsets.all(5.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        child: CachedNetworkImage(
                          imageUrl: "${data[index].image}",
                          fit: BoxFit.cover,
                          width: MediaQuery.of(context).size.width * 0.8,
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
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      onTap: () {
                        delete(data[index].sliderId);
                      },
                      child: Center(
                        child: Icon(Icons.delete),
                      ),
                    )
                  ],
                );
              },
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
                      onPressed: () async {
                        imgSrc = ImageSource.camera;
                        Navigator.pop(context, true);
                        pickedFile = await picker.getImage(source: imgSrc);
                        loading = true;
                        setState(() {});
                        await ServiceProviderService()
                            .addSliderImgs(io.File(pickedFile!.path));
                        getSilder();
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
                      onPressed: () async {
                        imgSrc = ImageSource.gallery;
                        Navigator.pop(context, true);
                        pickedFile = await picker.getImage(source: imgSrc);
                        loading = true;
                        setState(() {});
                        await ServiceProviderService()
                            .addSliderImgs(io.File(pickedFile!.path));
                        getSilder();
                      },
                    )
                  ],
                ),
              ],
            ));

    return done;
  }
}
