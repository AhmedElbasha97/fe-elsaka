import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  const Loader({Key? key, this.height=0, this.width=0}) : super(key: key);
final double height;
final double width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height==0?MediaQuery.of(context).size.height:height ,
      width: width==0?MediaQuery.of(context).size.width:width ,
      color:const Color(0x80000000),
      child: Center(
        child:Container(
          height: MediaQuery.of(context).size.height*0.1 ,
          width: MediaQuery.of(context).size.width*0.4 ,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            border: Border.all(width: 0.5, color:  Color(0xFF66a5b4)),
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5, //soften the shadow
                spreadRadius: 0, //extend the shadow
                offset: Offset(
                  0.0, // Move to right 10  horizontally
                  3.0, // Move to bottom 5 Vertically
                ),
              )
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  Localizations.localeOf(context).languageCode == "en" ?"Loading":"جاري التحميل"),
              const SizedBox(width: 15,),
              const CircularProgressIndicator(color:  Color(0xFF66a5b4),)

            ],
          ),
        ),
      ),
    ) ;
  }
}
