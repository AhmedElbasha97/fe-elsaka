// ignore_for_file: must_be_immutable, deprecated_member_use

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/cart_product.dart';
import 'package:FeSekka/model/category.dart';
import 'package:FeSekka/services/cart_services.dart';
import 'package:FeSekka/ui/payment_screen.dart';
import 'package:FeSekka/widgets/product_card.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';



class CartScreen extends StatefulWidget {
  List<WrokHours>? shifts;
  String? id;
  String? name;
  CartScreen({this.shifts, this.id, this.name});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isLoading = true;
  String? token;
  int? totalPrice;
  List<CartProductModel> productModelList = <CartProductModel>[];
  List<String?> cart = <String?>[];

  getData() async {
    await checkToken();
    if (token!.isNotEmpty) {
      await getProducts();
    }
    isLoading = false;
    setState(() {});
  }



  getProducts() async {
    productModelList = await CartServices().viewCart(true);
    productModelList.forEach((element) {
      cart.add(element.id);
    });
    totalPrice = CartServices.totalPrice;
  }

  checkToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
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
        backgroundColor: Colors.grey[300],
        title: Text(
          "سله المشتريات",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  productModelList == null || productModelList.isEmpty
                      ? Center(
                          child: Padding(
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              "${AppLocalizations.of(context)!.translate('noProducts')}",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        )
                      : ListView.builder(
                          primary: false,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: productModelList.length,
                          itemBuilder: (context, index) {
                            print(productModelList[index].id);
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 5),
                              child: LinearProductCard(

                                id: productModelList[index].id,
                                titleEn: productModelList[index].titleEn,
                                titleAr: productModelList[index].titleAr,
                                detailsEn: productModelList[index].categoryEn,
                                detailsAr: productModelList[index].categoryAr,
                                price: productModelList[index].price,
                                totalAmount: productModelList[index].quantity,
                                salePrice: productModelList[index].salePrice,
                                video: "",
                                addItemToCart: () {
                                  totalPrice = totalPrice! +
                                      double.parse(
                                              productModelList[index].price!)
                                          .toInt();
                                  setState(() {});
                                  Future.delayed(
                                      Duration(
                                        microseconds: 500,
                                      ), () async {
                                    if (token!.isNotEmpty) await getProducts();
                                    print(productModelList.length);
                                    setState(() {});
                                  });
                                },
                                removeItemFromCart: () async {
                                  totalPrice = totalPrice! <= 0
                                      ? 0
                                      : totalPrice! -
                                          double.parse(
                                                  productModelList[index].price!)
                                              .toInt();
                                  setState(() {});
                                  Future.delayed(
                                      Duration(
                                        microseconds: 500,
                                      ), () async {
                                    if (token!.isNotEmpty) await getProducts();
                                    print(productModelList.length);
                                    setState(() {});
                                  });
                                },
                                imgList:productModelList[index].photos,
                                image: productModelList[index].image, shareurl: '',
                              ),
                            );
                          },
                        ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  productModelList == null || productModelList.isEmpty
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            color: Colors.black,
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            "${"${AppLocalizations.of(context)!.translate('totalPrice')}"} : $totalPrice",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  productModelList == null || productModelList.isEmpty
                      ? Container()
                      : Padding(padding: EdgeInsets.only(top: 20)),
                  productModelList == null || productModelList.isEmpty
                      ? Container()
                      : InkWell(
                          onTap: () async {
                            await checkToken();
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                  cart: cart,
                                  name: widget.name,
                                  totalPrice: totalPrice,
                                  isSale: 0,
                                  shifts: widget.shifts),
                            ));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.5,
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              color: Colors.green,
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "${AppLocalizations.of(context)!.translate('buy')}",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                  Padding(padding: EdgeInsets.only(top: 40)),
                ],
              ),
            ),
    );
  }
}
