import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class ListTileCustomizao extends StatelessWidget {

  final IconData leading;
  final String texto;
  final Function onTap;

  ListTileCustomizao({this.leading, this.texto, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: this.onTap,
        child: ListTile(
          leading: Icon(
            this.leading,
            color: Colors.black,
          ),
          title: Align(
            alignment: Alignment(-1.3, 0),
            child: Text(
                this.texto,
                style: TextStyle(
                    fontSize: 18,
                )),
          ),
          trailing: Icon(
            AntDesign.right,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
