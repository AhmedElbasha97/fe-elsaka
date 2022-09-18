import 'package:flutter/material.dart';

class MyProductCard extends StatefulWidget {

  final String? titleEn;
  final String? price;
  final String? titleAr;
  final String? photo;


  MyProductCard({this.titleEn, this.price, this.titleAr, this.photo});

  @override
  _MyProductCardState createState() => _MyProductCardState();
}

class _MyProductCardState extends State<MyProductCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.19,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text("${widget.titleEn}",style: TextStyle(fontSize: 20,color: Colors.black),),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text("${widget.price}",style: TextStyle(color: Colors.black),),
                    )

                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.225,
                height: MediaQuery.of(context).size.height * 0.145,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    image: DecorationImage(
                        image: NetworkImage("${widget.photo}"),
                        fit: BoxFit.cover)),
                margin: EdgeInsets.only(left: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
