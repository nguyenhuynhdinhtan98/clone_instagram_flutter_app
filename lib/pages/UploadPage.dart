import 'dart:io';

import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/list_tile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  File imageFile;
  final picker = ImagePicker();
  bool serviceEnabled;
  LocationPermission permission;
  @override
  void initState() {
    super.initState();

    imageFile = File(
        "/storage/emulated/0/Android/data/com.example.clone_instagram_flutter_app/files/Pictures/scaled_image_picker764989931507624571.jpg");
  }

  TextEditingController locationTextEditingController = TextEditingController();
  Future<dynamic> getCurrentPosition() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    } else {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best,
          forceAndroidLocationManager: true);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark mPlaceMark = placemarks[0];
      String completeAddressInfo =
          await '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country},';
      String specificAddress =
          await '${mPlaceMark.locality}, ${mPlaceMark.country}';
      locationTextEditingController.text = specificAddress;
    }
  }

  captureImage(ImageSource imageSource) async {
    Navigator.pop(context);
    final pickedFile = await picker.getImage(
        source: imageSource,
        maxHeight: MediaQuery.of(context).size.height,
        maxWidth: MediaQuery.of(context).size.width / 3);
    setState(() {
      if (pickedFile != null) {
        print(pickedFile.path);
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
                    onPressed: () => captureImage(ImageSource.camera),
                    child: Container(
                      child: Text("Pick Image Camera"),
                    ),
                  ),
                  Divider(
                    color: Colors.grey,
                    height: 0.5,
                  ),
                  FlatButton(
                    onPressed: () => captureImage(ImageSource.gallery),
                    child: Container(
                      child: Text("Pick Image Gallery"),
                    ),
                  )
                ],
              ));
        });
  }

  renderUploadPage() {
    return Scaffold(
        appBar: header(
          context,
          strTitle: "Upload Page",
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
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
            )
          ],
        ));
  }

  shareFile() {}
  removeFile() {
    setState(() {
      imageFile = null;
    });
  }

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: removeFile,
        ),
        actions: [
          FlatButton(
              onPressed: shareFile,
              child: Text(
                "Share",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white),
              ))
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(
                child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                image: FileImage(imageFile),
                fit: BoxFit.fill,
              ),
            )),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ListTile(
                leading: Icon(
                  Icons.person_pin_circle,
                  color: Colors.black,
                  size: 36.0,
                ),
                title: Container(
                  child: TextField(
                    style: TextStyle(color: Colors.black),
                    controller: locationTextEditingController,
                    decoration: InputDecoration(
                      hintText: "Write the location here.",
                      hintStyle: TextStyle(color: Colors.black),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(35.0)),
                color: Colors.green,
                icon: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
                label: Text(
                  "Get my Current Location",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () => getCurrentPosition(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return imageFile == null ? renderUploadPage() : displayUploadFormScreen();
  }
}
