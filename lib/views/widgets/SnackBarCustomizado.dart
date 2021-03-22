import 'package:flutter/material.dart';

class SnackBarCustomizado extends StatelessWidget {
  final String texto;

  SnackBarCustomizado({this.texto});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text(this.texto),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.black,
    );
  }
}
