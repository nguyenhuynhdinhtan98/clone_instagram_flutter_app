import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:clone_instagram_flutter_app/widgets/ProgressWidget.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File imageFile;

  final picker = ImagePicker();

  captureImage(ImageSource imageSource) async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
        source: imageSource,
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width / 3);

    setState(() {
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  void displayBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        elevation: 5,
        enableDrag: true,
        isScrollControlled: false,
        context: context,
        builder: (ctx) {
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, blurRadius: 10.0, spreadRadius: 1)
                  ]),
              height: MediaQuery.of(context).size.height * 0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlatButton(
                    onPressed: captureImage(ImageSource.camera),
                    child: Container(
                      child: Text("Pick Image Camera"),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  FlatButton(
                    onPressed: captureImage(ImageSource.camera),
                    child: Container(
                      child: Text("Pick Image Gallery"),
                    ),
                  )
                ],
              ));
        });
  }

  Expanded renderBodyUploadPage() {
    return Expanded(
      flex: 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.add_a_photo,
            color: Colors.black,
            size: 50,
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5),
            child: RaisedButton(
              onPressed: () {
                displayBottomSheet(context);
              },
              color: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Text("Upload Image"),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: header(
          context,
          strTitle: "Upload Page",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            imageFile != null
                ? Container(
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image(
                        image: FileImage(imageFile),
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                : Container(),
            renderBodyUploadPage(),
          ],
        ));
  }
}
