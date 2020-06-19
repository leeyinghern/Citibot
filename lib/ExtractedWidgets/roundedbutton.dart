import 'package:flutter/material.dart';

class roundedbutton extends StatelessWidget {
  roundedbutton({@required this.color, @required this.title, @required this.onPressed});

  final Color color;
  final String title;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: color),
            borderRadius: BorderRadius.circular(5.0),
        ),
        child: Material(
          elevation: 5.0,
          color: color,
          borderRadius: BorderRadius.circular(5.0),
          child: MaterialButton(
            onPressed: onPressed,
            minWidth: 200.0,
            height: 42.0,
            child: Text(
              title,
              style: TextStyle(color: Colors.white,fontSize: 18.0),
            ),
          ),
        ),
      ),
    );
  }
}