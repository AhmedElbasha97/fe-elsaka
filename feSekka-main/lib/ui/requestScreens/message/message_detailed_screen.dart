import 'dart:io';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../model/messages_list_model.dart';

class MessageDetailedScreen extends StatelessWidget {
  const MessageDetailedScreen({Key? key, required this.data}) : super(key: key);
  final MessageListModel data;
  whatsapp(String contact) async {
    print(contact);
        if (Platform.isIOS) {
          var iosUrl = "https://wa.me/$contact?text=${Uri.parse(
              "you accepted my request In the application. Car Serv and I want to communecate with you.\n  لقد قبلت طلبى في تطبيق. كار سيرف وأريد التواصل معك   ")}";
          await launchUrl(Uri.parse(iosUrl));
        }
        else {
          var androidUrl = "whatsapp://send?phone=$contact&text= you accepted my request In the application. Car Serv and I want to communecate with you.\n  لقد قبلت طلبى في تطبيق. كار سيرف وأريد التواصل معك    ";


          await launchUrl(Uri.parse(androidUrl));


    }
  }
  _launchURL(String url,String nameOfSocialProgram) async {
    print("hiiiiiiii");
    print(url);
    if(url == "" || url == "https://wa.me/" || url == "tel:"){

    }
    if (await launchUrl(Uri.parse(url))) {

    } else {
      throw 'Could not launch $url';
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          Localizations.localeOf(context).languageCode == "en"
              ?"Message Details":"تفاصيل الرساله",
          style: TextStyle(color:  Color(0xFF66a5b4)),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color:  Color(0xFF66a5b4),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body:Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(1.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xFF66a5b4),width: 1),
                        shape: BoxShape.circle
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey,width: 1),
                          shape: BoxShape.circle
                      ),
                      child: const CircleAvatar(
                        radius: 40,
                        backgroundColor: Color(0xFF66a5b4),
                        child: Icon(
                          Icons.message,color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${Localizations.localeOf(context).languageCode == "en" ?data.providerNameEn:data.providerNameAr}",
                          style: const TextStyle(

                              color: Colors.black,
                              fontWeight: FontWeight.w800,
                              fontSize: 15),),
                        Text(
                          data.created??"",

                          style: const TextStyle(

                              color: Colors.grey,
                              fontWeight: FontWeight.w800,
                              fontSize: 15),
                          maxLines: null,
                        ),
                        InkWell(
                          onTap: (){
                            whatsapp(data.whatsapp??"");
                          },
                          child: Row(
                            children: [
                              Icon(Icons.message_sharp,color: Color(0xFF66a5b4),),
                              SizedBox(width: 5,),
                              Text(
                                Localizations.localeOf(context).languageCode == "en" ?"Communicate with the garage via WhatsApp":"التواصل مع الكراج عبر الواتس اب",

                                style: const TextStyle(

                                    color: Color(0xFF66a5b4),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12),
                                maxLines: null,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            _launchURL("tel:${data.mobile}","mobile");

                          },
                          child: Row(
                            children: [
                             Icon(Icons.call,color: Color(0xFF66a5b4),),
                              SizedBox(width: 5,),
                              Text(
                                Localizations.localeOf(context).languageCode == "en" ?"Call the garage by phone":"الأتصل بالكراج عبر الهاتف",
                                style: const TextStyle(

                                    color: Color(0xFF66a5b4),
                                    fontWeight: FontWeight.w800,
                                    fontSize: 12),
                                maxLines: null,
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                  ),

                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(1.0),
              decoration: BoxDecoration(
                border:  Border.all(color:  Color(0xFF66a5b4),width: 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(data.message??"",
                    style: const TextStyle(

                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15),
                    maxLines: null,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
