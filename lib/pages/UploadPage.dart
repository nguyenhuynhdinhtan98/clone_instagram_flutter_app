import 'dart:io';
import 'dart:ui';

import 'package:clone_instagram_flutter_app/models/user.dart';
import 'package:clone_instagram_flutter_app/pages/HomePage.dart';
import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:clone_instagram_flutter_app/widgets/ProgressWidget.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/list_tile.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Imd;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UploadPage extends StatefulWidget {
  final User gCurrentUser;

  UploadPage({this.gCurrentUser});

  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  String postId = Uuid().v4();
  bool uploadImage = false;
  File imageFile;
  final picker = ImagePicker();
  bool serviceEnabled;
  LocationPermission permission;
  TextEditingController locationTextEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  compressingPhoto() async {
    final tDirectory = await getTemporaryDirectory();
    final path = tDirectory.path;
    Imd.Image mImage = Imd.decodeImage(imageFile.readAsBytesSync());
    var compressImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Imd.encodeJpg(mImage, quality: 60));

    setState(() {
      imageFile = compressImageFile;
    });
  }

  uploadImageFireStore() async {
    setState(() {
      uploadImage = true;
    });
    await compressingPhoto();
    String downloadUrl = await uploadPhoto(imageFile);
    await savePostInfoToFireStore(
        url: downloadUrl, location: locationTextEditingController.text);
    clearPostInfo();
  }

  savePostInfoToFireStore({String url, String location}) {
    postsReference
        .doc(widget.gCurrentUser.id)
        .collection("usersPosts")
        .doc(postId)
        .set({
      "postId": postId,
      "ownerId": widget.gCurrentUser.id,
      "timestamp": DateTime.now(),
      "likes": {},
      "username": widget.gCurrentUser.username,
      "location": location,
      "url": url,
    });
  }

  clearPostInfo() {
    locationTextEditingController.clear();
    setState(() {
      postId = Uuid().v4();
      uploadImage = false;
      imageFile = null;
    });
  }

  Future<String> uploadPhoto(image) async {
    firebase_storage.UploadTask storageUploadTask =
        referenceFireStorage.child("post_$postId.jpg").putFile(imageFile);
    String urlDownload = await storageUploadTask.snapshot.ref.getDownloadURL();
    return urlDownload;
  }

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
          '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country},';
      String specificAddress =
          '${mPlaceMark.locality}, ${mPlaceMark.country}';
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

  displayUploadFormScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => clearPostInfo(),
        ),
        actions: [
          FlatButton(
              onPressed: uploadImageFireStore,
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
            uploadImage == true ? linearProgress() : Container(),
            Container(
                child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Image(
                image: FileImage(imageFile),
                fit: BoxFit.contain,
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
