import 'dart:async';

import 'package:citichatbot/ExtractedWidgets/roundedbutton.dart';
import 'package:citichatbot/screen/login_screen.dart';
import 'package:citichatbot/screen/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:progress_indicators/progress_indicators.dart';


class welcomescreen extends StatefulWidget {
  static String id = 'welcome';
  @override
  _welcomescreenState createState() => _welcomescreenState();
}

class _welcomescreenState extends State<welcomescreen> {
  bool loginpressed = false;
  bool registerpressed = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                SizedBox(height: 150.0,),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex:1,
                          child: Hero(
                            tag: 'logo',
                            child: Container(
                                child:Image.asset('images/Citibank_logo.png',height: 50.0,width: 50,) ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 100.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('Welcome...', style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Color(0xFF003b70)),),
                            SizedBox(width: 30.0,)
                          ],
                        ),
                        SizedBox(height: 10.0,),
                        Text('Please Log in or Register to continue', style: TextStyle(color: Colors.black45, fontSize: 21.0),),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 30.0,),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: roundedbutton(color:loginpressed==false? Colors.black12 : Color(0xFF003b70),title: 'Log In',onPressed: (){
                        setState(() {
                          loginpressed = true;
                        });
                        Timer(Duration(milliseconds: 300), () {Navigator.pushNamed(context, loginscreen.id);
                        setState(() {
                          loginpressed = false;
                        });});
                      }),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: roundedbutton(color: registerpressed==false? Colors.black12 :Color(0xFFD9261C),title: 'Register',onPressed: (){
                        setState(() {
                          registerpressed = true;
                        });

                        Timer(Duration(milliseconds: 300), () {Navigator.pushNamed(context, registrationscreen.id);
                        setState(() {
                          registerpressed = false;
                        });});
                      }),
                    ),

                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
