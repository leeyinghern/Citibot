import 'dart:io';
import 'package:citichatbot/ExtractedWidgets/roundedbutton.dart';
import 'package:citichatbot/extractedfunctions/providerfunctions.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'menu_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:citichatbot/screen/chatbot_screen.dart';

class registrationscreen extends StatefulWidget {
  static String id = 'registration';
  @override
  _registrationscreenState createState() => _registrationscreenState();
}

class _registrationscreenState extends State<registrationscreen> {
  final _auth = FirebaseAuth.instance;
  bool showspinner = false;
  String email;
  String password;
  String url = null;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              userimagepicker(),  //pay attention to this line. We reload state using a stateful widget here
              SizedBox(height: 20.0,),
              TextField(
                textAlign: TextAlign.left,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  email = value;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(Icons.email),
                  hintText: 'Enter your email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black26, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black26, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              SizedBox(height: 10.0,),
              TextField(
                obscureText: true,
                textAlign: TextAlign.left,
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  icon: Icon(Icons.vpn_key),
                  hintText: 'Enter your password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black26, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.black26, width: 0.0),
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              roundedbutton(color: Color(0xFFD9261C),title: 'Register',onPressed: ()async{
                FocusScope.of(context).unfocus();
                setState(() {
                  showspinner = true;
                });
                try{
                  final newuser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                  final ref = FirebaseStorage.instance.ref().child('userimages').child(newuser.user.uid +'.jpg'); //create path if it doesn't exist
                  if (Provider.of<outsidefunctions>(context,listen: false).image!=null){
                    await ref.putFile(Provider.of<outsidefunctions>(context,listen: false).image!=null? Provider.of<outsidefunctions>(context,listen: false).image: null).onComplete; //this uploads file to the specified path.
                    // It uses the last segment of the path as the file name. Add onComplete to return a Future.
                    url = await ref.getDownloadURL(); // returns a Future that retrieves a long lived URL for anyone that wants to view that image
                  }
                  if(newuser != null){
//                    Navigator.pushNamed(context, menuscreen.id);
                    Navigator.pushNamed(context, chatbotscreen.id,);
                  }
                  setState(() {
                    showspinner=false;
                  }
                  );
                  await Firestore.instance.collection('users').document(newuser.user.uid).setData({'email':email,'password':password,'avatarimage':url});
                }catch(e){
                  print(e);
                Widget buildbottomsheet (BuildContext context){
                  return Column(
                    children: <Widget>[
                      Text(e.toString())
                    ],
                  );
                }
                showModalBottomSheet(context: context, builder: buildbottomsheet);
                setState(() {
                  showspinner=false;
                });
                }
                ;},),
            ],
          ),
        ),
      ),
    );
  }
}


class userimagepicker extends StatefulWidget {
  @override
  _userimagepickerState createState() => _userimagepickerState();
}

class _userimagepickerState extends State<userimagepicker> {

  Widget picksource() {
    setState(() {
      showDialog(context: context,
        builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Choose Image Source"),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            IconButton(icon: Icon(Icons.camera_alt),onPressed: (){
              Provider.of<outsidefunctions>(context,listen: false).pickcameraimage();
              Navigator.of(context).pop();},),
            IconButton(icon: Icon(Icons.add_photo_alternate),onPressed: (){
              Provider.of<outsidefunctions>(context,listen: false).pickgalleryimage();
              Navigator.of(context).pop();

            })
          ],),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
      );
    });
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(
          backgroundColor: Colors.black45,
          radius: 40.0,
          child: CircleAvatar(
            backgroundColor: Colors.white,
            radius: 39.0,
            child: Transform.scale(scale:3.0,
                child: IconButton(
                  icon: Icon(Icons.person_outline,color: Colors.black38,),

              onPressed: (){
                picksource();
              },)),
//            backgroundImage:
//            Provider.of<outsidefunctions>(context).image != null ?
//            FileImage(Provider.of<outsidefunctions>(context).image) :
//            AssetImage('images/empty.png'),
          ),
        ),

      ],
    );
  }
}


