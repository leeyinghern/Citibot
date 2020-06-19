import 'package:citichatbot/screen/chat_screen.dart';
import 'package:citichatbot/screen/chatbot_screen.dart';
import 'package:citichatbot/screen/taskscreen.dart';
import 'package:flutter/material.dart';

class menuscreen extends StatefulWidget {
  static String id = 'menu';

  @override
  _menuscreenState createState() => _menuscreenState();
}

class _menuscreenState extends State<menuscreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context).settings.arguments; //used to retrieve arguments
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child:
                GestureDetector(
                    child: Icon(Icons.chat),
                    onTap: (){Navigator.pushNamed(context, chatscreen.id);},
                ),),
              Expanded(child: GestureDetector(child: Icon(Icons.adb),
                onTap: (){Navigator.pushNamed(context, chatbotscreen.id, arguments: {'url':args});},),)
            ],
          ),
//          SizedBox(height: 100.0,),
//          Row(
//            children: <Widget>[
//              Expanded(child:
//              GestureDetector(
//                child: Icon(Icons.format_list_numbered),
//                onTap: (){Navigator.pushNamed(context, taskscreen.id);},
//              ),),
//            ],
//          ),
        ],
      ),
    );
  }
}

