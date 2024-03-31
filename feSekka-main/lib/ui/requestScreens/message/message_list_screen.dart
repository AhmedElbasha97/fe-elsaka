import 'package:flutter/material.dart';

import '../../../model/messages_list_model.dart';
import '../../../services/request_services.dart';
import '../../../widgets/loader.dart';
import 'message_cell_widget.dart';

class MessageListScreen extends StatefulWidget {
  final orderId;
  const MessageListScreen({Key? key, this.orderId}) : super(key: key);

  @override
  State<MessageListScreen> createState() => _MessageListScreenState();
}

class _MessageListScreenState extends State<MessageListScreen> {
  bool isLoading = true;
  List<MessageListModel> data = [];
  @override
  void initState() {
    super.initState();
    getData();
  }
  getData() async {
    data = await requestServices().getMessagesList(widget.orderId);
    print(data[0]);

    isLoading = false;
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.grey[50],
        title: Text(
          Localizations.localeOf(context).languageCode == "en" ?"Garage Messages":"رسائل الكراجات",
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
              return MessageCellWidget(data: data[index],);
            }
        ),
      ),
    );
  }
}
