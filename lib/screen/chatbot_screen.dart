import 'dart:async';
import 'dart:io';
import 'package:citichatbot/ExtractedWidgets/roundedbutton.dart';
import 'package:citichatbot/extractedfunctions/providerfunctions.dart';
import 'package:citichatbot/screen/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'callscreen.dart';


class chatbotscreen extends StatefulWidget {
  static String id = 'chatbot';

  @override
  _chatbotscreenState createState() => _chatbotscreenState();
}

class _chatbotscreenState extends State<chatbotscreen> {

  final _firestore = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedinuser;
  String userid;
  final TextEditingController textController = TextEditingController();

  @override
  initState(){
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(onMessage: (msg){
      print('here');
      print(msg);
      return;
    },
    onLaunch: (msg){
      print('here');
      print(msg);
      return;
    },
    onResume: (msg){
      print('here');
      print(msg);
      return;
    },
    );
    super.initState();
    getuserdetails();
//    Provider.of<outsidefunctions>(context,listen: false).avatargeturl(); //this works too
  }
  void getuserdetails() async{
    try{
      final currentuser = await _auth.currentUser();
      final String uid = await currentuser.uid;
      final args = ModalRoute.of(context).settings.arguments;
      if(currentuser !=null) {
        loggedinuser = currentuser;
        userid = uid;
      }
      await Provider.of<outsidefunctions>(context,listen: false).avatargeturl();

    }catch(e){
        print(e);
    }
  }
  Widget imagekeyboard (){
    return Container(
        height: 100.0,
        width: 100.0,
        alignment: Alignment.center,
        child: new Stack(alignment: Alignment.center, children: <Widget>[
          Image(image: AssetImage('images/empty.png')),
        ]),
      );
  }

  Widget rating(){
    return RatingBar(
      initialRating: 3,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.amber,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  //for the checklist
  Map<String, bool> values = {
    'Look and Feel': false,
    'Ease of finding services': false,
    'Ease of use': false,
    'Technical Issues': false,
    'Language clarity': false,
    'Others': false,
  };


  Widget openratingscreen(){
    return ListView(
      reverse: true,
      shrinkWrap: true,
      children: <Widget>[
      Dialog(
        child: Container(
            padding:EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0) ,
            child:
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children:Provider.of<outsidefunctions>(context,listen: false).completerating==false? <Widget>[
              Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      SizedBox(height:20.0,),
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(icon: Icon(Icons.close),onPressed: (){
                          setState((){
                            Provider.of<outsidefunctions>(context, listen: false).currentmessages.clear();
                            Provider.of<outsidefunctions>(context, listen: false).completerating=true;
                          });
                          setState(() async{
                            await Future.delayed(const Duration(seconds: 5));
                            setState(() {
                              Provider.of<outsidefunctions>(context, listen: false).completerating=false;
                              Provider.of<outsidefunctions>(context, listen: false).rating=false;
                            });
                          });
                        },),
                      ),
                    ],
                  ),
                  Stack(children: <Widget>[
                    Align(
                      child: Text('How would you rate your overall experience today?',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.0),
                          textAlign: TextAlign.center),
                      alignment: Alignment.bottomCenter,
                    ),

                  ],),
                ],
              ),

              SizedBox(height: 10.0,),
              rating(),
              SizedBox(height: 20.0,),
              Column(
                children: values.keys.map((String key) {
                  return new CheckboxListTile(
                    title: Text(key),
                    value: values[key],
                    onChanged: (bool value) {
                      setState(() {
                        values[key] = value;
                      });
                    },
                  );
                }).toList(),
              ),
              Row(children: <Widget>[
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0),
                      color: Colors.white,
//                                                border: Border(left: BorderSide(color: Color(0xFF003b70), width: 3)),
//                                        boxShadow: [
//                                          BoxShadow(color: Color(0xFF003b70), spreadRadius: 2),
//                                        ],
                    ),
                    child: Row(
                      children: <Widget>[
                        Flexible(
                          child: TextField(
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black45),
                            controller: textController,
                            decoration:
                            InputDecoration.collapsed(hintText: "Feedback (optional)",
                              hintStyle: TextStyle(fontSize: 15.0, color: Colors.black45,),),
                          ),
                        ),
//                              IconButton(icon: Icon(Icons.send, color: Color(0xFF003b70)),onPressed: (){
//                                textController.clear();
//                                FocusScope.of(context).unfocus();
//                              },),
                      ],
                    ),
                  ),
                ),
              ],),
              roundedbutton(title: 'Submit',color: Color(0xFF003b70),onPressed: (){
                setState((){
                  Provider.of<outsidefunctions>(context, listen: false).currentmessages.clear();
                  Provider.of<outsidefunctions>(context, listen: false).completerating=true;
                });
                setState(() async{
                  await Future.delayed(const Duration(seconds: 5));
                  setState(() {
                    Provider.of<outsidefunctions>(context, listen: false).completerating=false;
                    Provider.of<outsidefunctions>(context, listen: false).rating=false;
                  });
                });
              },),
            ]:<Widget>[Column(
              children: <Widget>[
                Text('Thank you for your feedback!',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0),),
              ],
            ),]
          ))
        ),
        SizedBox(height:70),
    ].reversed.toList(),
    );
  }

  Widget _buildTextComposer() {
    return new IconTheme(
      data: new IconThemeData(color: Theme.of(context).accentColor),
      child: new Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: new Row(
          children: <Widget>[
            Flexible(
              child:
                Provider.of<outsidefunctions>(context).messagebarimage != null ?
                    Stack(children: <Widget>[
                      TextField(
                        controller: Provider.of<outsidefunctions>(context).textController,
                        onSubmitted: Provider.of<outsidefunctions>(context).handleSubmitted,
                        decoration:
                        InputDecoration.collapsed(hintText: "Send a message"),
                      ),
                      Image.file(Provider.of<outsidefunctions>(context).messagebarimage,),
                    ],)
                    : TextField(
                  controller: Provider.of<outsidefunctions>(context).textController,
                  onSubmitted: Provider.of<outsidefunctions>(context).handleSubmitted,
                  decoration:
                  InputDecoration.collapsed(hintText: "Send a message"),
                ),
            ),
            Row(
                children: <Widget>[
                  GestureDetector(child: Icon(Icons.attach_file),onTap: (){
                    openratingscreen();
                  },),

                  SizedBox(width: 5.0,),
                  GestureDetector(child: Icon(Icons.camera_alt),onTap: (){
                    Widget buildbottomsheet (BuildContext context){
                      return Row(
                        children: <Widget>[
                          IconButton(icon: Icon(Icons.photo_camera),
                              onPressed: ()async{
                                Provider.of<outsidefunctions>(context,listen: false).messagecameraimage();
                                FocusScope.of(context).unfocus();
                                Navigator.of(context).pop();

                              }),
                          IconButton(icon: Icon(Icons.photo_library),
                            onPressed: ()async{
                              Provider.of<outsidefunctions>(context,listen: false).messagegalleryimage();
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            },),
                        ],
                      );
                    }
                    showModalBottomSheet(context: context, builder: buildbottomsheet);

                    },),
                  SizedBox(width: 10.0,),
                  GestureDetector(
                    child: Icon(Icons.send),
                    // For the send message button
                    onTap: (){
                      Provider.of<outsidefunctions>(context, listen: false).messagebarimage !=null ?
                      setState(() {
                        Provider.of<outsidefunctions>(context, listen: false).handleSubmittedimage();
                        Provider.of<outsidefunctions>(context, listen: false).resetimage();
                      }): Provider.of<outsidefunctions>(context,listen: false).handleSubmitted(Provider.of<outsidefunctions>(context,listen: false).textController.text);
//                      Provider.of<outsidefunctions>(context, listen: false).calling == true ?
////                      Timer(Duration(seconds: 3), () {
////                        Navigator.push(context,
////                            MaterialPageRoute(
////                                builder: (context)=>
////                                    callscreen(
////                                      name: Provider.of<outsidefunctions>(context,listen: false).dccname,
////                                      number: Provider.of<outsidefunctions>(context,listen: false).dccnumber,)));
////                      }): null;
                      },),
                  SizedBox(width: 5.0,),
                ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<outsidefunctions>(context, listen: false).calling == true ?
    Timer(Duration(seconds: 3), () {
      Navigator.push(context,
          MaterialPageRoute(
              builder: (context)=>
                  callscreen(
                    name: Provider.of<outsidefunctions>(context,listen: false).dccname,
                    number: Provider.of<outsidefunctions>(context,listen: false).dccnumber,)));
    }): null;


    List <Widget>topics = [];
    void _openAddEntryDialog() {
      Navigator.of(context).push(new MaterialPageRoute<Null>(
          builder: (BuildContext context) {
            return AddEntryDialog(topics:topics);
          },
          fullscreenDialog: true
      ));
    }


      return Scaffold(
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Center(child: Text(
                  'Select a Topic', style: TextStyle(color: Colors.white),)),
                decoration: BoxDecoration(
                  color: Color(0xFF003b70),
                ),
              ),

              // Items in the side menu
              ListTile(
                title: Text('Update Personal Particulars'),
                trailing: Icon(Icons.arrow_right),
                onTap: () {
                  setState(() {
                    // Nested Menu
                    topics.add(ListTile(title: Text('Update my Name'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my name');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    topics.add(ListTile(title: Text('Update Address'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my address');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    topics.add(ListTile(title: Text('Update Contact Number'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my contact number');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    topics.add(ListTile(title: Text('Update address'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my address');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    topics.add(ListTile(title: Text('Update Email Address'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my email address');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    topics.add(ListTile(title: Text('Update nationality'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my nationality');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    topics.add(ListTile(title: Text('Update Passport'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my passport');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    topics.add(ListTile(title: Text('Update Marital Status'),
                        onTap: () {
                          Provider.of<outsidefunctions>(context, listen: false)
                              .handleSubmitted(
                              'I would like to update my marital status');
                          Navigator.of(context).popUntil(
                              ModalRoute.withName('chatbot'));
                          topics.clear();
                        }));
                    _openAddEntryDialog();
                  });
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 3'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 4'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 5'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 6'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 7'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 8'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 9'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Item 10'),
                onTap: () {
                  // Update the state of the app.
                  Navigator.pop(context);
                },
              ),

            ],
          ),
        ),
        appBar: new AppBar(
          iconTheme: IconThemeData(color: Color(0xFF003b70)),
          centerTitle: true,
          title: Container(
              child: Image.asset('images/appbar.png', width: 140.0)),
          backgroundColor: Colors.white,
        ),
        body:  Stack(
          children: <Widget>[

            Column(children: <Widget>[
              Flexible(
                  child: new ListView.builder(
                    padding: new EdgeInsets.all(8.0),
                    reverse: true,
                    itemBuilder: (_, int index) =>
                    Provider
                        .of<outsidefunctions>(context)
                        .currentmessages[index],
                    itemCount: Provider
                        .of<outsidefunctions>(context)
                        .currentmessages
                        .length,
                  )),
              new Divider(height: 1.0),
              new Container(
                decoration: new BoxDecoration(color: Theme
                    .of(context)
                    .cardColor),
                child: _buildTextComposer(),
              ),

            ]),
            Provider.of<outsidefunctions>(context, listen:false).rating==true?
            Provider.of<outsidefunctions>(context,listen: false).displayrating(openratingscreen()):
            Provider.of<outsidefunctions>(context,listen: false).displayrating(Container()),
          ],
        )
      );

  }
}


class ChatMessage extends StatefulWidget {
  ChatMessage({this.text, this.name, this.type, this.suggestion,this.avatarurl});
  Widget text;
  final String name;
  final List suggestion;
  final bool type;
  final String avatarurl;

  @override
  _ChatMessageState createState() => _ChatMessageState();
}

class _ChatMessageState extends State<ChatMessage> {
  List <Widget> buttons = [];
  bool buttoncolor;

  List<Widget> otherMessage(context) {
    buttons.clear();
    if (widget.suggestion!=null){
      for (var input in widget.suggestion){
        buttons.add(FlatButton(child: Text(input),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Color(0xFF1b6ca8))
          ),

          color: Colors.white,
          textColor:Color(0xFF1b6ca8),
          onPressed: (){
            Provider.of<outsidefunctions>(context, listen:false).handleSubmitted(input);

          }),
        );
      }
      final buttonmap = buttons.asMap();

      List <Widget> stackedcolumn(){
        int count = 0;
        List<Widget> toadd = [];
        toadd.clear();
        while(count<buttons.length){
          toadd.add(Row(children: <Widget>[buttonmap[count], SizedBox(width: 4.0,),buttonmap.containsKey(count+1) ? buttonmap[count+1]: Container()],));
          count= count+2;
        }
        return toadd;
      }
      return <Widget>[
        Container(
          margin: const EdgeInsets.only(right: 16.0,top: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              CircleAvatar(child: CircleAvatar(child: Text('B',style: TextStyle(color: Color(0xFF1b6ca8),fontWeight: FontWeight.bold)),radius: 20,backgroundColor: Colors.white),backgroundColor: Color(0xFFd92027),radius: 22,),
            ],
          ),
        ),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Material(
            shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(15.0), bottomRight: Radius.circular(10.0)) ),
            elevation: 10.0,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top:6.0,right: 10.0, bottom: 6.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(this.widget.name, style: new TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      margin: const EdgeInsets.only(top: 5.0),
                      child: widget.text,
                ),
              ],)
            )
          ),

            SizedBox(height:10.0),


            SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: stackedcolumn()
                )
            ),
          ],

        )
        )
      ];
    }else{
      return <Widget>[
        // The circle avatar is housed in a container
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(right: 10.0,top: 5.0),
                child: CircleAvatar(
                  child: CircleAvatar(
                    child: Text('B',style: TextStyle(color: Color(0xFF1b6ca8),fontWeight: FontWeight.bold),),radius: 20,backgroundColor: Colors.white,),backgroundColor: Color(0xFFd92027),radius: 22,),
              ),
              // Body of the text message spans the entire screen
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Material(
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(10.0),topRight: Radius.circular(15.0), bottomRight: Radius.circular(10.0)) ),
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top:6.0,right: 10.0, bottom: 6.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(this.widget.name,  //name for the chatbubble for the chatbot. DO NOT CHANGE
                                style: new TextStyle(fontWeight: FontWeight.bold)),
                            // This contains the text message style
                            Container(
                              margin: const EdgeInsets.only(top:8.0),
                              child: widget.text,
                            ),
                          ],),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ];
    }
  }

  List<Widget> myMessage(context) {
      return <Widget>[
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Material(
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.only(topLeft: Radius.circular(15.0),topRight: Radius.circular(15.0),bottomLeft: Radius.circular(15.0)) ),
                      elevation: 10.0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top:6.0,right: 10.0, bottom: 6.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            new Text(Provider.of<outsidefunctions>(context).useremail[0].toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold)), //name INSIDE the chatbubble for user. CHANGE
                            new Container(
                              margin: const EdgeInsets.only(top: 8.0),
                              child: widget.text,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16.0,top:8.0),
                child: new CircleAvatar(
                  backgroundImage: Provider.of<outsidefunctions>(context).avatarimageurl!= "null" ?
                  NetworkImage(Provider.of<outsidefunctions>(context).avatarimageurl.toString()): null,
//            backgroundImage: Provider.of<outsidefunctions>(context).avatarimageurl!= null ?
//            NetworkImage(Provider.of<outsidefunctions>(context).avatarimageurl.toString()): null,
                  child:
                  Provider.of<outsidefunctions>(context).avatarimageurl!= "null" ?
                  null:
                  Text(Provider.of<outsidefunctions>(context).useremail[0].toUpperCase(), style: TextStyle(fontWeight: FontWeight.bold),),

//            child: Provider.of<outsidefunctions>(context).avatarimageurl!=null ?
//            NetworkImage(Provider.of<outsidefunctions>(context).avatarimageurl) :
//            Image.asset('images/empty.png'),
                ),
              ),
            ],
          ),
        )

      ];
  }

  @override
  Widget build(BuildContext context) {
    buttons.clear();
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: this.widget.type ? myMessage(context) : otherMessage(context),
        ),
      );
    }
}

class AddEntryDialog extends StatefulWidget {
  AddEntryDialog({this.topics});
  final List<Widget> topics;
  @override
  AddEntryDialogState createState() => new AddEntryDialogState();
}

class AddEntryDialogState extends State<AddEntryDialog> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Frequently Asked Questions'),
      ),
      body: ListView(
          children: <Widget>[
            Column(
              children: widget.topics,
            ),
          ]
      ),
    );
  }
}

