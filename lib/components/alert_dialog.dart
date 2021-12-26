import 'dart:ui';
import 'package:flutter/material.dart';

class AlertView extends StatelessWidget {
  final String title;
  final String content;
  final Function continueFunction;

  AlertView(
      {Key? key,
      required this.title,
      required this.content,
      required this.continueFunction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1), //add blur
        child: AlertDialog(
          backgroundColor: Colors.white,
          title: Center(
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Greycliff CF Bold",
                  color: Colors.red),
            ),
          ),
          content: Text(
            content,
            maxLines: 3,
            style: TextStyle(
                fontSize: 16,
                fontFamily: "Greycliff CF Medium",
                color: Colors.black),
          ),
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(9)),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.black,
                animationDuration: Duration(milliseconds: 1000),
              ),
              child: FittedBox(
                child: Text(
                  "Tamam",
                  style: TextStyle(
                      fontSize: 14,
                      fontFamily: "Greycliff CF Bold",
                      color: Colors.blue),
                ),
              ),
              onPressed: () {
                continueFunction();
              },
            ),
          ],
        ));
  }
}
