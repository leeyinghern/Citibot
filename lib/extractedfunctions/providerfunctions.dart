import 'package:citichatbot/screen/chatbot_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'dart:io';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:url_launcher/url_launcher.dart';

class outsidefunctions extends ChangeNotifier{
  final firestore = Firestore.instance;
  var auth = FirebaseAuth.instance;
  FirebaseUser loggedinuser;
  String avatarimageurl;
  String useremail;
  int counter = 0;
  bool calling = false;
  int dccnumber;
  String dccname;
  bool rating=false;
  bool completerating= false;

  final List<Widget> currentmessages = <Widget>[];
  final TextEditingController textController = TextEditingController();
  final List<String> forstorage = <String>[];
  final Map<int, File> imagefiles = <int, File>{};

  Future <String> avatargeturl()async{
    final currentuser = await auth.currentUser();
    final String uid = await currentuser.uid;
    if(currentuser !=null) {
      loggedinuser = currentuser;
      useremail = loggedinuser.email;
    }
    var data = await firestore.collection('users').document(loggedinuser.uid).get();
    avatarimageurl = data.data['avatarimage'].toString();
  }

  // inside provider, create a function that returns a widget a container, which takes in a widget argument as the child
  // in the chatbotscreen, pass the ratingscreen into the provider function.
  // in the build method, wrap the column in a stack. Stack child = Listview + ratingscreen or empty container depending on provider boolean

  Widget displayrating(Widget todisplay){
    if (rating == false){
      return Container(child: todisplay,);
    }
    else if(rating==true){
      return Container(child:todisplay);
    }
    notifyListeners();
  }

  File image;
  File messageimage;
  File messagebarimage;
  final picker = ImagePicker();

  Future pickgalleryimage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery, imageQuality: 50, maxHeight: 50);
    image = File(pickedFile.path);
    notifyListeners();
  }
  Future pickcameraimage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera, imageQuality: 50, maxWidth: 50);
    image = File(pickedFile.path);
    notifyListeners();
  }

  Future messagegalleryimage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery,imageQuality: 100);
    messageimage = File(pickedFile.path);
    messagebarimage = messageimage;
    notifyListeners();
  }

  Future messagecameraimage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera,imageQuality: 100);
    messageimage = File(pickedFile.path);
    messagebarimage = messageimage;
    notifyListeners();
  }

  void resetimage(){
    messagebarimage = null;

  }

  void getcallscreen() {
    calling = true;
    dccnumber = 97121681;
    dccname = 'Nicholle Ho';
  }

  Future<void> _onOpen(LinkableElement link) async {
    if (await canLaunch(link.url)) {
      await launch(link.url);
    } else {
      throw 'Could not launch $link';
    }
  }


  void Response(query) async {
    Widget link=Container();
    String i;
    textController.clear();
    Widget loader = Container(margin:EdgeInsets.only(top:5.0),child: GlowingProgressIndicator(
        child: Transform.scale(scale:1.5,child: Icon(Icons.more_horiz))),);
    currentmessages.insert(0,loader);
    notifyListeners();
    AuthGoogle authGoogle = await AuthGoogle(fileJson: "assets/credentials.json").build();
    Dialogflow dialogflow = Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse response = await dialogflow.detectIntent(query);
//    print(response.getListMessage()[0]['text']['text'][0].split(' ').runtimeType);
    for(String item in response.getListMessage()[0]['text']['text'][0].split(' ')){
      item.contains(new RegExp(r'http', caseSensitive: false)) ? i = item: null;
      item.contains(new RegExp(r'http', caseSensitive: false)) ? link = Linkify(
        onOpen: _onOpen,
        text: item,
      ):null;
    }


    try{
      print(response.getListMessage());

      if (await response.getListMessage()[0]['text']['text'][0].contains('Calling your DCC')){
        dccnumber = int.parse(response.getListMessage()[0]['text']['text'][0].split(' ').last);
        getcallscreen();
      }

      //check for suggestion length, pass the widgets directly to stateless widget
      if (response.getListMessage().length>1){
//      print(response.getListMessage());
        ChatMessage message = ChatMessage(
          text: await response.getListMessage()!=null? Text(await response.getListMessage()[0]['text']['text'][0]):'Something went wrong',
          name: "Bot",
          type: false,
          suggestion: await response.getListMessage()[1]['payload']!=null ?
          await response.getListMessage()[1]['payload']['suggestions']:
          await response.getListMessage()[1]['quickReplies']['quickReplies'],
          avatarurl: null,
        );

        currentmessages.removeWhere((item) => item == loader);
        notifyListeners();
        currentmessages.insert(0, message);
        notifyListeners();

        if(i!=null){
          ChatMessage messagelink = ChatMessage(
            text: Linkify(
              onOpen: _onOpen,
              text: i,
            ),
            name: "Bot",
            type: false,
            suggestion: null,
            avatarurl: null,
          );
          currentmessages.insert(0, messagelink);
          notifyListeners();
          i = null;
        }
      }

      else {
        ChatMessage message = ChatMessage(
          // double question mark = if null. String a = b ?? 'hello'; If b is null, then set a equal to hello
          text: await response.getListMessage()[0]['text']['text'][0] !=null?
          await Text(response.getListMessage()[0]['text']['text'][0]):
          'Something went wrong',

          name: "Bot",
          type: false,
          suggestion: null,
          avatarurl: null,
        );
        currentmessages.removeWhere((item) => item == loader);

        notifyListeners();
        await currentmessages.insert(0, message);
        notifyListeners();

        if(i!=null){
          ChatMessage messagelink = ChatMessage(
            text: Linkify(
              onOpen: _onOpen,
              text: i,
            ),
            name: "Bot",
            type: false,
            suggestion: null,
            avatarurl: null,
          );
          currentmessages.insert(0, messagelink);
          notifyListeners();
          i = null;
        }
      }
    }
    catch(e){
      ChatMessage message = ChatMessage(
        text: Text('Something went wrong try sending another answer.'),
        name: "Bot",
        type: false,
        suggestion: null,
        avatarurl: null,
      );
      currentmessages.removeWhere((item) => item == loader);
      notifyListeners();
      currentmessages.insert(0, message);
    }
  }

  //handle submitted was here
  // Here, we create a message and append it to the messages list. which then triggers the Listview.builder
  void handleSubmitted(String text) async{
    textController.clear();
    Widget loader = Container(margin:EdgeInsets.only(top:5.0),child: GlowingProgressIndicator(
        child: Transform.scale(scale:1.5,child: Icon(Icons.more_horiz))),);
    for (Widget items in currentmessages){
      if (items == loader){
        currentmessages.remove(items);
      }
    }
    print(text);
    List <String> checks = [ 'Call','call','CALL','CALLING','Calling'];

    for (var item in text.split(' ')){
//      print(item);
      if (checks.contains(item)||item=='Call'){
        getcallscreen();
        notifyListeners();
      }
      else{calling = false;}
    }

    if(text=='Nothing else. Rate the app.'){
      rating = true;
      notifyListeners();
    }

    ChatMessage message = new ChatMessage(
      text: Text(text),
      name: useremail,
      type: true,
      suggestion: null,
      avatarurl: avatarimageurl,
    );
    currentmessages.insert(0, message);
    await Response(text);
    calling = false;
    notifyListeners();
  }

  void handleSubmittedimage() async{
    textController.clear();
    counter ++;
    imagefiles[counter] = messageimage;
    Widget loader = Container(margin:EdgeInsets.only(top:5.0),child: GlowingProgressIndicator(
        child: Transform.scale(scale:1.5,child: Icon(Icons.more_horiz))),);
    currentmessages.removeWhere((item) => item == loader);
    await currentmessages.insert(0,
        Column(
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
                    new Text(useremail[0].toUpperCase(),
                        style: TextStyle(fontWeight: FontWeight.bold)), //name INSIDE the chatbubble for user. CHANGE
                    new Container(
                      margin: const EdgeInsets.only(top: 8.0),
                      child: Image.file(imagefiles[counter],),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
    await Response('submitted my document');
    final ref = FirebaseStorage.instance.ref().child('for_verification').child(loggedinuser.uid +'${loggedinuser.email}.jpg');
    if (imagefiles[counter]!=null){
      await ref.putFile(imagefiles[counter]!=null? imagefiles[counter]: null).onComplete;
    }
    notifyListeners();
    resetimage();
  }



}






