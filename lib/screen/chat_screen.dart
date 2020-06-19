import 'package:citichatbot/ExtractedWidgets/newmessage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class chatscreen extends StatefulWidget {
  static String id = 'chat';
  @override
  _chatscreenState createState() => _chatscreenState();
}

class _chatscreenState extends State<chatscreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        backgroundColor: Colors.white,
        title: Container(child: Image.asset('images/appbar.png', width:140.0)),),
      body: Container(child:
      Column(
        children: <Widget>[
          messages(),
          messagebar(),
        ],),),
    );
  }
}

//used to output messages from Firebase
//messages are documents in the collection
class messages extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder( //takes in a future, and once the future resolves, it calls the builder
        future: FirebaseAuth.instance.currentUser(),
        builder: (context, futuresnapshot){
          if(futuresnapshot.connectionState==ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }
          return StreamBuilder(
            stream: Firestore.instance.collection('messages').orderBy('time',descending: true).snapshots(),
            builder: (context,chatSnapshot){
              if(chatSnapshot.connectionState==ConnectionState.waiting){
                return(Center(child: CircularProgressIndicator(),));
              }
              final chatdocs = chatSnapshot.data.documents;
              return ListView.builder(
                    itemCount: chatdocs.length,
                    itemBuilder: (context, index){
                      return messagebubble(chatdocs[index]['text'], chatdocs[index]['userid'] == futuresnapshot.data.uid, ValueKey(chatdocs[index].documentID));
                    }, reverse: true,);
            },
          );
        },
      )
    );
  }
}

class messagebar extends StatefulWidget {
  @override
  _messagebarState createState() => _messagebarState();
}

class _messagebarState extends State<messagebar> {
  var _enteredmessage = '';
  final TextEditingController textController = TextEditingController();

  void _sendmessage()async{
//    FocusScope.of(context).unfocus(); // //makes the keyboard retract
    textController.clear();
    final user = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('messages').add({'text':_enteredmessage,'time':Timestamp.now(),'userid':user.uid});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8.0),

      child: Row(children: <Widget>[
        Expanded(child: TextField(controller: textController,
          decoration: InputDecoration(labelText: 'Send a Message'),
          onChanged: (value){
            _enteredmessage = value;
          },
        )),
        IconButton(color: Colors.blue,icon: Icon(Icons.send),
          onPressed: _sendmessage,),
      ],),

    );
  }
}

class messagebubble extends StatelessWidget {
  final String message;
  messagebubble(this.message, this.isme, this.key);
  final bool isme;
  final Key key;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isme? MainAxisAlignment.end: MainAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: isme ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(12.0),topRight: Radius.circular(12),
                bottomLeft: !isme? Radius.circular(0) : Radius.circular(12.0),
            bottomRight: isme? Radius.circular(0) : Radius.circular(12.0),),
          ),
          width: 140,
          padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 16.0),
          margin: EdgeInsets.symmetric(vertical: 4,horizontal: 8),
          child: Text(message, style: TextStyle(color: isme? Colors.white: Colors.black),),
        ),
      ],
    );
  }
}

