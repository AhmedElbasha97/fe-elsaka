import 'package:flutter/material.dart';

import '../../../model/messages_list_model.dart';
import 'message_detailed_screen.dart';

class MessageCellWidget extends StatelessWidget {
  final MessageListModel data;
  const MessageCellWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  InkWell(
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => MessageDetailedScreen( data: data,),
        ));
      },
      child: Container(
        width: double.infinity,
        child:  Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Color(0xFF66a5b4),
                child: Icon(
                  Icons.message,color: Colors.white,
                ),
              ),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${Localizations.localeOf(context).languageCode == "en" ?data.providerNameEn:data.providerNameEn}",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),
                        maxLines: null,
                      ),
                      SizedBox(height: 8),
                      Text(
                        data.message??"",
                        style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold ),
                        maxLines: null,
                      ),
                      SizedBox(height: 8),
                      Opacity(
                        opacity: 0.64,
                        child: Text(
                          data.created??"",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight
                                .bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.shade500,width: 1)
            )
        ),

      ),
    );
  }
}
