import 'package:flutter/material.dart';

class MyOrderCategoryCard extends StatefulWidget {
  final String? title;
  final String? status;
  final String? date;
  final String? photo;
  final bool? isMyOrder;
  final Widget? extraWidget;

  MyOrderCategoryCard(
      {this.title,
      this.status,
      this.date,
      this.photo,
      this.isMyOrder,
      this.extraWidget});

  @override
  _MyOrderCategoryCardState createState() => _MyOrderCategoryCardState();
}

class _MyOrderCategoryCardState extends State<MyOrderCategoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Material(
        elevation: 5,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.23,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(12))),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: widget.status == "confirm"
                                ? Colors.green
                                : Color(0xFFFFB151),
                            shape: BoxShape.circle,
                          ),
                        ),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                        Text("${widget.status}",
                            style: TextStyle(color: Colors.black))
                      ],
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        "${widget.title}",
                        style: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30)),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "${widget.date}",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10)),
                    Center(
                        child:
                            widget.isMyOrder! ? widget.extraWidget : Container())
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
