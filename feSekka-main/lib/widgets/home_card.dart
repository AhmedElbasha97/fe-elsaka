// ignore_for_file: must_be_immutable, unused_element

import 'package:FeSekka/model/category.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeCard extends StatefulWidget {
  String? title;
  String? image;
  String? facebookUrl;
  String? whatsappUrl;
  String? instagramUrl;
  String? snapChatUrl;
  String? twitterUrl;
  List<Sub>? subCategory;

  HomeCard({this.image,this.title,this.subCategory,this.facebookUrl,this.snapChatUrl,this.whatsappUrl,this.twitterUrl,this.instagramUrl});

  @override
  _HomeCardState createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {



  bool expandFlag = false;

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: CachedNetworkImage(
        imageUrl: "${widget.image}",
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 100.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return  AnimatedContainer(
      duration:  Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: Column(

        children: [
          Padding(padding: EdgeInsets.symmetric(vertical: 2),),
          expanded ? SizedBox(width: MediaQuery.of(context).size.width*0.7,child: Divider(thickness: 1,),):Container(),
          Padding(padding: EdgeInsets.symmetric(vertical: 2),),
          Container(
              decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
    boxShadow: [
      BoxShadow(color: Colors.green, spreadRadius: 3),
    ],
  ),
            child: child,
          ),
        ],
      ) ,
    );
  }
}