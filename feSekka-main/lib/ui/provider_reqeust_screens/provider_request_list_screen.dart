
import 'package:FeSekka/ui/provider_reqeust_screens/provider_request_list_cell.dart';
import 'package:flutter/material.dart';
import '../../model/provider_request_list_model.dart';
import '../../services/request_services.dart';
import '../../widgets/loader.dart';

class ProviderRequestListScreen extends StatefulWidget {
  const ProviderRequestListScreen({key});

  @override
  State<ProviderRequestListScreen> createState() => _AddNewRequestScreenState();
}

class _AddNewRequestScreenState extends State<ProviderRequestListScreen> {

  bool isLoading = true;
  List<ProviderRequestListModel> data = [];
  String? token;
  @override
  void initState() {
    super.initState();
    getData();
  }
  getData() async {
    data = await requestServices().getProviderRequests();
    print(data[0]);

    isLoading = false;
    setState(() {});
  }

  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          Localizations.localeOf(context).languageCode == "en" ?"Order List":"قائمه الطلبات",
          style: TextStyle(color: Color(0xFF66a5b4),
              fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFF66a5b4),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading?Loader():data.length==0?Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width*0.9,
              child: Image.asset("assets/photos/Car accesories-amico.png",fit: BoxFit.fitHeight,),
            ),
            SizedBox(height: 10,),
            Text(
                Localizations.localeOf(context).languageCode == "en" ?"There are no requests yet":"لا يوجد طلبات حتى الأن",  style: TextStyle(fontSize: 20, color: Colors.grey)),
            SizedBox(height: 10,),

          ],
        ),
      ):Container(
        width:  MediaQuery.of(context).size.width,
        child: ListView.builder(
            primary: false,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return ProviderRequestListCell(carData: data[index],);
            }
        ),
      ),
    );
  }
}