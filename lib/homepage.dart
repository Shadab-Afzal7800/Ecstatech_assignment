import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<File?> imageFiles = [null, null, null];
  void selectedImage(ImageSource source, int containerIndex) async {
    XFile? pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      cropImage(pickedFile, containerIndex);
    }
  }

  void cropImage(XFile file, int containerIndex) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1));
    if (croppedImage != null) {
      setState(() {
        imageFiles[containerIndex] = File(croppedImage.path);
      });
    }
  }

  void showSourceOptions(int containerIndex) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Select Image From"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectedImage(ImageSource.gallery, containerIndex);
                  },
                  leading: Icon(Icons.photo_album),
                  title: Text("Gallery"),
                ),
                ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    selectedImage(ImageSource.camera, containerIndex);
                  },
                  leading: Icon(Icons.camera_alt),
                  title: Text("Camera"),
                )
              ],
            ),
          );
        });
  }

  Widget _buildImageContainer(int containerIndex) {
    double containerSize = MediaQuery.of(context).size.width / 2;
    return Container(
      height: containerSize,
      width: containerSize,
      decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
      child: imageFiles[containerIndex] != null
          ? Image.file(
              imageFiles[containerIndex]!,
              fit: BoxFit.cover,
            )
          : Center(
              child: Text("No Image Selected"),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text("Ecstatech Assignment"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageContainer(0),
            _buildImageContainer(1),
            _buildImageContainer(2),
            SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text("Select Image"),
                  onPressed: () {
                    showSourceOptions(0);
                  },
                ),
                ElevatedButton(
                  child: Text("Select Image"),
                  onPressed: () {
                    showSourceOptions(1);
                  },
                ),
                ElevatedButton(
                  child: Text("Select Image"),
                  onPressed: () {
                    showSourceOptions(2);
                  },
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
