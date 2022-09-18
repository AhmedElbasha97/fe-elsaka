// ignore_for_file: must_be_immutable

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/services/appInfo.dart';
import 'package:flutter/material.dart';

class SendMessageScreen extends StatefulWidget {
  String? id;
  SendMessageScreen({this.id});
  @override
  _SendMessageScreenState createState() => _SendMessageScreenState();
}

class _SendMessageScreenState extends State<SendMessageScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _msgController = new TextEditingController();
  TextEditingController _phoneController = new TextEditingController();

  FocusNode _emailNode = new FocusNode();
  FocusNode _nameNode = new FocusNode();
  FocusNode _msgNode = new FocusNode();
  FocusNode _phoneNode = new FocusNode();

  void unFocus() {
    _emailNode.unfocus();
    _nameNode.unfocus();
    _msgNode.unfocus();
    _phoneNode.unfocus();
    if (mounted) setState(() {});
  }

  sendMsg() async {
    isLoading = true;
    setState(() {});
    if (_formKey.currentState!.validate()) {
      await AppInfoService().sendComplement(
          email: _emailController.text,
          name: _nameController.text,
          message: _msgController.text,
          mobile: _phoneController.text,
          id: widget.id);
      Navigator.of(context).pop();
      showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                title: Text(
                  AppLocalizations.of(context)!.translate('SuccessfulSend')!,
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                actions: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MaterialButton(
                        child: Row(
                          children: <Widget>[
                            Text(
                                AppLocalizations.of(context)!.translate('done')!),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ));
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  bool emailvalidator(String email) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    return emailValid;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => unFocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF66a5b4),
          title: Text(AppLocalizations.of(context)!.translate('complaient')!,
              style: TextStyle(color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 30),
            children: <Widget>[
              CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.asset(
                  "assets/icon/logo.png",
                  width: 120,
                  height: 120,
                ),
                radius: 70.0,
              ),
              SizedBox(
                height: 35,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  AppLocalizations.of(context)!.translate('complaientMsg')!,
                  style: TextStyle(fontSize: 17),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  focusNode: _nameNode,
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.people),
                    counterText: "",
                    hintText: AppLocalizations.of(context)!.translate('name'),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 1) {
                      return AppLocalizations.of(context)!
                          .translate('nameError');
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  focusNode: _phoneNode,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.phone),
                    counterText: "",
                    hintText:
                        AppLocalizations.of(context)!.translate('phoneNumber'),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value!.length < 1) {
                      return AppLocalizations.of(context)!
                          .translate('phoneError');
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextFormField(
                  focusNode: _emailNode,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    counterText: "",
                    hintText: AppLocalizations.of(context)!.translate('email'),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  ),
                  validator: (value) {
                    if (value == "" || emailvalidator(value!) == false) {
                      return AppLocalizations.of(context)!
                          .translate('emailError');
                    }
                    return null;
                  },
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                  validator: (value) {
                    if (value!.length < 2) {
                      return AppLocalizations.of(context)!
                          .translate('MessageError');
                    }
                    return null;
                  },
                  focusNode: _msgNode,
                  controller: _msgController,
                  maxLines: 4,
                  textAlign: TextAlign.right,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.translate('typeMsg'),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 2.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFF66a5b4), width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                  )),
              SizedBox(
                height: 15,
              ),
              Center(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: InkWell(
                          onTap: () {
                            sendMsg();
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 40,
                            decoration: BoxDecoration(
                                color: Color(0xFF66a5b4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context)!.translate('send')!,
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
