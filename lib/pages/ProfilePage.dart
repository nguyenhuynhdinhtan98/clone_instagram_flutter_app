import 'package:flutter/material.dart';
import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:clone_instagram_flutter_app/widgets/ProgressWidget.dart';

class ProfilePage extends StatefulWidget {
  String userProfileId;
  ProfilePage({this.userProfileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        strTitle: "Profile Page",
      ),
      body: circularProgress(),
    );
    ;
  }
}
