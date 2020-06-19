import 'package:citichatbot/screen/callscreen.dart';
import 'package:citichatbot/screen/chat_screen.dart';
import 'package:citichatbot/screen/chatbot_screen.dart';
import 'package:citichatbot/screen/login_screen.dart';
import 'package:citichatbot/screen/registration_screen.dart';
import 'package:citichatbot/screen/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:citichatbot/screen/menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';
import 'extractedfunctions/providerfunctions.dart';


void main() => runApp(citichat());

class citichat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<outsidefunctions>(
      create: (context){
        return outsidefunctions();
      },
      child: MaterialApp(
        initialRoute: welcomescreen.id,
        routes: {welcomescreen.id:(context){return welcomescreen();},
          loginscreen.id:(context){return loginscreen();},
          registrationscreen.id:(context){return registrationscreen();},
          chatscreen.id:(context){return chatscreen();},
          menuscreen.id:(context){return menuscreen();},
          chatbotscreen.id:(context){return chatbotscreen();},
          callscreen.id:(context){return callscreen();},
          }
      ),
    );
  }
}
