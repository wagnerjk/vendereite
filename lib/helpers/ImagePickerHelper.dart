import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper{
  final picker = ImagePicker();
  File image;

  Future<File> getImage() async{
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    if(pickedFile != null){
      image = File(pickedFile.path);
    }
    return image;
  }
}