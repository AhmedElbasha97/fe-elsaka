import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';

class SupportChatPage extends StatefulWidget {
  @override
  _SupportChatPageState createState() => _SupportChatPageState();
}

class _SupportChatPageState extends State<SupportChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Tawk(
          directChatLink:
              'https://tawk.to/chat/6078259af7ce1827093ab3f2/1f3al5p6d',
          visitor: TawkVisitor(),
          onLoad: () {
            print('Hello Tawk!');
          },
          onLinkTap: (String url) {
            print(url);
          },
          placeholder: Center(
            child: Text('Loading...'),
          ),
        ));
  }
}