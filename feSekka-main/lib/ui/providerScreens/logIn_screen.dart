import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/globals/utils.dart';
import 'package:FeSekka/services/serviceProvider.dart';
import 'package:FeSekka/ui/providerScreens/OrdersScreen.dart';
import 'package:FeSekka/ui/providerScreens/signUpProviderscreen.dart';
import 'package:flutter/material.dart';

class LoginProviderScreen extends StatefulWidget {
  @override
  _LoginProviderScreenState createState() => _LoginProviderScreenState();
}

class _LoginProviderScreenState extends State<LoginProviderScreen> {
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool phoneError = false;
  bool passwordError = false;
  bool isServerLoading = false;

  validation(BuildContext context) async {
    if (phoneController.text.isEmpty)
      phoneError = true;
    else
      phoneError = false;
    if (passwordController.text.isEmpty)
      passwordError = true;
    else
      passwordError = false;

    setState(() {});

    if (!phoneError && !passwordError) {
      isServerLoading = true;
      setState(() {});
      bool response = await ServiceProviderService()
          .serviceProviderlogin(phoneController.text, passwordController.text);
      if (response) {
        pushPageReplacement(context, OrderScreen());
      } else {
        final snackBar = SnackBar(
            content: Text(
                "${AppLocalizations.of(context)!.translate('loginFailed')}"));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      isServerLoading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFF0D986A),
          title: Text(
            "${AppLocalizations.of(context)!.translate('loginAsProvider')}",
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(false),
          ),
        ),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                  ),
                  Image.asset(
                    "assets/icon/logo.png",
                    scale: 2,
                  ),
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: phoneController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0D986A))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0D986A))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText:
                                  "${AppLocalizations.of(context)!.translate('phoneNumber')}"),
                        ),
                      ),
                      phoneError
                          ? Text(
                              "please enter your phone",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 10)),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: TextField(
                          controller: passwordController,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 25,
                                vertical: 15,
                              ),
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0D986A))),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide:
                                      BorderSide(color: Color(0xFF0D986A))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  borderSide: BorderSide(color: Colors.green)),
                              hintText:
                                  "${AppLocalizations.of(context)!.translate('password')}"),
                        ),
                      ),
                      passwordError
                          ? Text(
                              "please enter your password",
                              style: TextStyle(color: Colors.red),
                            )
                          : Container(),
                      Padding(padding: EdgeInsets.only(top: 25)),
                      isServerLoading
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : InkWell(
                              onTap: () => validation(context),
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                  color: Color(0xFF0D986A),
                                ),
                                child: Text(
                                    "${AppLocalizations.of(context)!.translate('login')}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                          onTap: () {
                            pushPage(context, SignUpProviderScreen());
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Color(0xFF0D986A),
                            ),
                            child: Text(
                                "${AppLocalizations.of(context)!.translate('newProvider')}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        ));
  }
}
