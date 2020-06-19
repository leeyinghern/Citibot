import 'package:citichatbot/ExtractedWidgets/roundedbutton.dart';
import 'package:citichatbot/extractedfunctions/providerfunctions.dart';
import 'package:citichatbot/screen/menu_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:citichatbot/screen/chatbot_screen.dart';


class loginscreen extends StatefulWidget {
  static String id = 'login';
  @override
  _loginscreenState createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  bool showspinner = false;
  final _firestore = Firestore.instance;
  String avatarurl;

  // TO RETRIEVE A SPECIFIC DOCUMENT FROM THE DATABASE
  Future <String> geturl() async {
    try{
      final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
      final currentuser = await _auth.currentUser();
      final String uid = await currentuser.uid;
      var data = await _firestore.collection('users').document(currentuser.uid).get();
      avatarurl = await data.data['avatarimage'].toString();
//      String mail = await data.data['email'].toString();
//      String pw = await data.data['password'].toString();
//      print(avatarurl);
    }catch(e){
      print(e.toString());
    }
  }

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
              Hero(
                tag: 'logo',
                child: Image.asset(
                  'images/Citibank_logo.png',
                  height: 60.0,
                ),
              ),
              SizedBox(height: 70.0,),
              Text('Welcome...', style: TextStyle(color: Color(0xFF003b70), fontSize: 35.0, fontWeight: FontWeight.bold),),
              SizedBox(height: 5.0,),
              Text('Please login to your account', style: TextStyle(color: Colors.black45, fontSize: 21.0),),
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
                        Radius.circular(20.0),
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
              SizedBox(height:10.0),
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
                        Radius.circular(20.0),
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
              SizedBox(height: 20.0,),
              roundedbutton(color: Color(0xFF003b70),title: 'Log In',onPressed: ()async{
                geturl();
                FocusScope.of(context).unfocus();
                setState(() {
                  showspinner = true;
                });
                try{
                  final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                  if (user !=null){
//                    Navigator.pushNamed(context, menuscreen.id, arguments:{'url':avatarurl});
                    Navigator.pushNamed(context, chatbotscreen.id, arguments:{'url':avatarurl});
                    geturl();
                  }
                  setState(() {
                    showspinner = false;
                  });
                }catch(e){
                  print(e);
                  Widget buildbottomsheet (BuildContext context){
                    return Column(
                      children: <Widget>[
                        Text(e.toString())
                      ],
                    );
                  };
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
