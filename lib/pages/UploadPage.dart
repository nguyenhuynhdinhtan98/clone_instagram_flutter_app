import 'package:flutter/material.dart';
import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:clone_instagram_flutter_app/widgets/ProgressWidget.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        strTitle: "Upload Page",
      ),
      body: circularProgress(),
    );
    ;
  }
}
