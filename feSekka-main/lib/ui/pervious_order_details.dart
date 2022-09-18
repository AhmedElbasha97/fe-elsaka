// ignore_for_file: must_be_immutable

import 'package:FeSekka/I10n/app_localizations.dart';
import 'package:FeSekka/model/orders.dart';
import 'package:FeSekka/widgets/myProduct_card.dart';
import 'package:flutter/material.dart';

class PreviousOrderDetails extends StatefulWidget {
  List<Product>? products;
  String? totalPrice;
  String? providerName;
  String? providerImg;

  PreviousOrderDetails(
      this.products, this.totalPrice, this.providerName, this.providerImg);

  @override
  _PreviousOrderDetailsState createState() => _PreviousOrderDetailsState();
}

class _PreviousOrderDetailsState extends State<PreviousOrderDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        title: Text(
          "${AppLocalizations.of(context)!.translate('myProducts')}",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ListTile(
              tileColor: Colors.white,
              trailing: Text("${widget.providerName ?? ''}"),
              title: Container(
                width: MediaQuery.of(context).size.width * 0.1,
                height: MediaQuery.of(context).size.height * 0.1,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                        image: NetworkImage("${widget.providerImg}"),
                        fit: BoxFit.cover)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.products!.length,
              itemBuilder: (context, index) {
                return MyProductCard(
                  titleAr: widget.products![index].titleAr,
                  titleEn: widget.products![index].titleEn,
                  price: widget.products![index].price,
                  photo: widget.products![index].image,
                );
              },
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
            Container(
              width: MediaQuery.of(context).size.width * 0.5,
              padding: EdgeInsets.symmetric(vertical: 15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.black,
              ),
              alignment: Alignment.center,
              child: Text(
                "${AppLocalizations.of(context)!.translate('totalPrice')} : ${widget.totalPrice}",
                style: TextStyle(color: Colors.white),
              ),
            ),
            Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top)),
          ],
        ),
      ),
    );
  }
}
