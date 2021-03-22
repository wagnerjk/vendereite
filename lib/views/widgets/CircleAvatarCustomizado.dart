import 'dart:io';

import 'package:flutter/material.dart';

class CircleAvatarCustomizado extends StatelessWidget {
  final Function onTap;
  final File image;
  final String url;

  CircleAvatarCustomizado({this.onTap, this.image, this.url = ""});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      /*onTap: () async {
        image = await ImagePickerHelper().getImage();
        _isImage = true;
        setState(() {});
      },
       */
      onTap: this.onTap,
      child: CircleAvatar(
        backgroundColor: Colors.grey[400],
        radius: 50,
        backgroundImage: this.image != null
            ? FileImage(this.image)
            //: AssetImage("assets/images/add-image-icon.jpg"),
            //: NetworkImage("https://cdn2.iconfinder.com/data/icons/picol-vector/32/image_add-512.png")
            : this.url != "" ? NetworkImage(this.url) : AssetImage("assets/images/add-image-icon.jpg")
      ),
    );
  }
}
