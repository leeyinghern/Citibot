//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class taskscreen extends StatelessWidget {
//  static String id = 'task';
//  String message;
//  Widget buildbottomsheet (BuildContext context){
//    return Container(
//      color: Color(0xff757575), //do this because we cannot directly edit the edges of the bottom sheet
//      child: Container(
//        padding: EdgeInsets.all(20.0),
//        decoration: BoxDecoration(
//          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0),),
//          color: Colors.white,),
//        child: Column(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//          children: <Widget>[
//            Text('Add Task', style: TextStyle(fontSize: 30.0, color: Colors.lightBlueAccent),textAlign: TextAlign.center,),
//            // autofocus makes the keyboard pop up automatically
//            TextField(autofocus: true,textAlign: TextAlign.center,onChanged: (value){message = value;}),
//            SizedBox(height:20),
//            FlatButton(child: Text('Add', style: TextStyle(color: Colors.white),),color: Colors.lightBlueAccent, onPressed: (){}, ),
//          ],
//        ),
//      ),
//    );
//  }
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      backgroundColor: Colors.lightBlueAccent,
//      floatingActionButton: FloatingActionButton(
//        backgroundColor: Colors.lightBlueAccent,
//        onPressed: (){showModalBottomSheet(context: context, builder: buildbottomsheet);},
//        child: Icon(Icons.add),),
//      body: Column(
//        crossAxisAlignment: CrossAxisAlignment.start,
//        children: <Widget>[
//          Container(
//            padding: EdgeInsets.only(top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
//            child: Column(
//              crossAxisAlignment: CrossAxisAlignment.start,
//              children: <Widget>[
//                CircleAvatar(child: Icon(Icons.list, size: 30.0, color: Colors.lightBlueAccent,), backgroundColor: Colors.white,radius: 30.0,),
//                SizedBox(height: 10.0,),
//                Text('Tasks', style: TextStyle(color: Colors.white, fontSize: 50.0, fontWeight: FontWeight.w700),),
//                Text('12 Tasks', style: TextStyle(color: Colors.white, fontSize: 18.0),),
//              ],
//            ),
//          ),
//          Expanded(
//            child: Container(
//              padding: EdgeInsets.symmetric(horizontal: 20.0),
//              height: 300.0,
//              decoration: BoxDecoration(
//                color: Colors.white,
//                borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0),),
//              ),
//              child: TaskList(),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//}
//
//class TaskList extends StatefulWidget {
//  @override
//  _TaskListState createState() => _TaskListState();
//}
//
//class _TaskListState extends State<TaskList> {
//  List  <TaskTile> taskwidgets = [
//    TaskTile(),
//  ];
//  @override
//  Widget build(BuildContext context) {
//    return ListView.builder(itemBuilder: (context, index){
//      return TaskTile();
//    }
//    );
//  }
//}
//
//class TaskTile extends StatefulWidget {
//  @override
//  _TaskTileState createState() => _TaskTileState();
//}
//
//class _TaskTileState extends State<TaskTile> {
//  bool ischecked = false;
//  String title;
//
//  void checkboxcallback (bool value){setState(() {
//    ischecked = value;
//  });}
//
//  @override
//  Widget build(BuildContext context) {
//    return ListTile(
//      title: Text('Test', style: TextStyle(decoration: ischecked ? TextDecoration.lineThrough: null),),
//      trailing: taskcheckbox(checked: ischecked,checkboxstate: checkboxcallback,),
//    );
//  }
//}
//
//class taskcheckbox extends StatelessWidget {
//  final bool checked;
//  final Function checkboxstate;
//  taskcheckbox({this.checked, this.checkboxstate});
//
//  @override
//  Widget build(BuildContext context) {
//    return Checkbox(value: checked, activeColor: Colors.lightBlueAccent,
//    // onchanged changes the value in the check box. So when user presses it, it changes automatically,
//      // new value is the value that the checkbox sends after user checks.
//    onChanged: checkboxstate,
//    );
//  }
//}
//
