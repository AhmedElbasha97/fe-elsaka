import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/model/provider/subcategoryProvider.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/providerScreens/addCat.dart';
import 'package:flutter/material.dart';

class SubCatPage extends StatefulWidget {
  @override
  _SubCatPageState createState() => _SubCatPageState();
}

class _SubCatPageState extends State<SubCatPage> {
  bool isLoading = true;
  List<SubCategory> list = [];

  getData() async {
    list = await ServiceProviderService().getSubcatogies();
    isLoading = false;
    setState(() {});
  }

  deleteCat(String? id) async {
    isLoading = true;
    setState(() {});
    await ServiceProviderService().deletesubCatogry(id);
    getData();
  }

  @override
  void initState() {
    super.initState();
    getData();
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
                    pushPage(context, AddCatogoryPage());
                  },
                  icon: Icon(Icons.add)),
            )
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(
                          Localizations.localeOf(context).languageCode == "en"
                              ? "${list[index].titleen}"
                              : "${list[index].titlear}"),
                      leading: Container(
                          width: 70,
                          height: 70,
                          child: Image.network("${list[index].image}")),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          deleteCat(list[index].subcategoryId);
                        },
                      ),
                    ),
                  );
                },
              ));
  }
}
