import 'dart:async';
import 'dart:io';
import 'package:citichatbot/extractedfunctions/providerfunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class callscreen extends StatefulWidget {

  callscreen({this.number, this.name});
  final int number;
  final String name;
  static String id = 'callscreen';
  @override
  _callscreenState createState() => _callscreenState();
}

class _callscreenState extends State<callscreen> {

  @override
  initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 30.0),
        color: Color(0xFF003b70),
        child: ListView(
          children:<Widget>[
            SizedBox(height: 100.0,),
            Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(child: Text(Provider.of<outsidefunctions>(context,listen: false).dccname, style: TextStyle(
                  color: Colors.white, fontSize: 30.0
              ),),),
//            Container(child: Text(time),),
              SizedBox(height: 200.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(children: <Widget>[
                    CircleAvatar(radius: 35.0,backgroundColor:Colors.white30,
                      child: IconButton(iconSize:35.0,icon: Icon(Icons.mic_off, color: Colors.white,)),),
                      SizedBox(height: 15.0,),
                      Text('Mute', style: TextStyle(color: Colors.white, fontSize: 15.0),),
                  ],),
                  Column(children: <Widget>[
                    CircleAvatar(radius: 35.0,backgroundColor:Colors.white30,
                      child: IconButton(iconSize:35.0,icon: Icon(Icons.dialpad, color: Colors.white),),),
                    SizedBox(height: 15.0,),
                      Text('Keypad', style: TextStyle(color: Colors.white, fontSize: 15.0),),
                  ],),
                  Column(children: <Widget>[
                    CircleAvatar(radius: 35.0,backgroundColor:Colors.white30,
                      child: IconButton(iconSize:35.0,icon: Icon(Icons.mic, color: Colors.white),),),
                    SizedBox(height: 15.0,),
                    Text('Speaker', style: TextStyle(color: Colors.white, fontSize: 15.0),),
                  ],),
                ],),
              SizedBox(height: 120.0,),

//              Row(
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  CircleAvatar(radius: 25.0,backgroundColor:Colors.white30,child: IconButton(iconSize:30.0,icon: Icon(Icons.add, color: Colors.white),),),
//                  SizedBox(width: 40.0,),
//                  CircleAvatar(radius: 25.0,backgroundColor:Colors.white30,child: IconButton(iconSize:30.0,icon: Icon(Icons.videocam, color: Colors.white),),),
//                  SizedBox(width: 40.0,),
//                  CircleAvatar(radius: 25.0,backgroundColor:Colors.white30,child: IconButton(iconSize:30.0,icon: Icon(Icons.contacts, color: Colors.white),),),
//                ],),
//              SizedBox(height: 10.0,),
//              Row(
//                children: <Widget>[
//                  SizedBox(width: 35,),
//                  Text('Add Call', style: TextStyle(color: Colors.white, fontSize: 15.0),),
//                  SizedBox(width: 30.0,),
//                  Text('FaceTime', style: TextStyle(color: Colors.white, fontSize: 15.0),),
//                  SizedBox(width: 30.0,),
//                  Text('Contacts', style: TextStyle(color: Colors.white, fontSize: 15.0),),
//                ],),
////            SizedBox(height: 75.0,),
//              SizedBox(height:40.0),

//              Row(children: <Widget>[
//                Flexible(
//                  child: Container(
//                    padding: EdgeInsets.all(0.0),
//                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
//                      color: Colors.white,
////                    border: Border(left: BorderSide(color: Color(0xFF003b70), width: 3))
//                      boxShadow: [
//                        BoxShadow(color: Color(0xFF003b70), spreadRadius: 2),
//                      ],
//                    ),
//                    child: Row(
//                      children: <Widget>[
//                        Flexible(
//                          child: TextField(
//                            textAlign: TextAlign.center,
//                            style: TextStyle(color: Colors.black45),
//                            controller: textController,
////                            onSubmitted: Provider.of<outsidefunctions>(context).handleSubmitted,
////                            onSubmitted: print('feedback submitted'),
//                            decoration:
//                            InputDecoration.collapsed(hintText: "Tell us why you were unhappy",
//                              hintStyle: TextStyle(fontSize: 15.0, color: Colors.black45,),),
//                          ),
//                        ),
//                        IconButton(icon: Icon(Icons.send, color: Color(0xFF003b70)),onPressed: (){
//                          textController.clear();
//                        },),
//                      ],
//                    ),
//                  ),
//                ),
//              ],),

//              SizedBox(height:10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    radius: 35.0,
                    backgroundColor: Colors.red,
                    child: IconButton(iconSize:35.0,icon: Icon(Icons.call_end, color: Colors.white,),
                      onPressed: (){
                        setState(() {
                          Provider.of<outsidefunctions>(context, listen: false).calling = false;
                          Navigator.of(context).popUntil(ModalRoute.withName('chatbot'));
                        });
                      },),
                  ),
                ],),
            ],
          ),]
        ),
      ),
    );
  }
}