import 'package:flutter/material.dart';

import '../../model/message_response_model.dart';
import '../../services/request_services.dart';

class SendingMessageScreen extends StatefulWidget {
  const SendingMessageScreen({Key? key, required this.orderId}) : super(key: key);
  final String orderId;
  @override
  _SendingMessageScreenState createState() => _SendingMessageScreenState();
}

class _SendingMessageScreenState extends State<SendingMessageScreen> {
  bool loading = false;
  final TextEditingController msgController =  TextEditingController();
  final formKey = GlobalKey<FormState>();

  final FocusNode msgNode =  FocusNode();
  sendingMessage() async {
   var formValidated = formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (formValidated) {
      loading = true;
      setState(() {});
      MessageResponseModel? data = await requestServices().sendingMessageToClient(widget.orderId,msgController.text);
      if(data?.status??false) {
        loading = false;
        setState(() {});
        final snackBar = SnackBar(content:
        Row(children: [
          Icon(Icons.check,color: Colors.white,),
          SizedBox(width: 10,),
          Text('تم أرسال الرساله بنجاح',style: TextStyle(
            color: Colors.white,
          fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor:Colors.green
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }else{
        loading = false;
        setState(() {});
        final snackBar = SnackBar(content:
        Row(children: [
          Icon(Icons.close,color: Colors.white,),
          SizedBox(width: 10,),
          Text('تم أرسال الرساله لا تستطيع أرسال رساله أخرى',style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold
          ),
          ),
        ],),
            backgroundColor:Colors.red
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

    }

  }
  String? massageValidator( String? value){

    if (value!.length < 2||value.isEmpty) {
      return "الرسالة مطلوبة";
    }
    return null;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar:  AppBar(
            backgroundColor: Colors.grey[50],
            title: Text(
              Localizations.localeOf(context).languageCode == "en" ?"Sending a Message ":"أرسال رساله ",
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
      body: SingleChildScrollView(
        child:  Form(
          key:formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                    validator:massageValidator,
                    focusNode: msgNode,
                    controller: msgController,
                    maxLines: 4,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: Localizations.localeOf(context).languageCode == "en" ?"Send a message to the customer":"أرسال رساله الى العميل",
                      focusedBorder:  OutlineInputBorder(
                        borderSide:
                        BorderSide(color: Color(0xFF66a5b4), width: 2.0),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                      enabledBorder:  OutlineInputBorder(
                        borderSide:
                        BorderSide(color:  Color(0xFF66a5b4), width: 1.0),
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                      ),
                    )),
              ),
              Padding(padding: EdgeInsets.only(top: 25)),
              loading? CircularProgressIndicator(color: Color(0xFF66a5b4),):InkWell(
                onTap: () async {
                 await sendingMessage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    color:Color(0xFF66a5b4),
                  ),
                  child: Text(
                      Localizations.localeOf(context).languageCode == "en" ?"Sending a Message ":"أرسال الرساله",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
