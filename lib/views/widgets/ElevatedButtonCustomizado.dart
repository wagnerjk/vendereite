import 'package:flutter/material.dart';

class ElevatedButtonCustomizado extends StatelessWidget {

  final String text;
  final Function onPressed;

  ElevatedButtonCustomizado({this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: this.onPressed,
        style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            primary: Theme.of(context).primaryColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6))),
        child: Text(
          this.text,
          style: TextStyle(fontSize: 18),
        ));
  }
}
