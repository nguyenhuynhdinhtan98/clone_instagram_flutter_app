import 'package:flutter/material.dart';
import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:clone_instagram_flutter_app/widgets/ProgressWidget.dart';

class TimeLinePage extends StatefulWidget {
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(
        context,
        strTitle: "Time Line Page",
      ),
      body: circularProgress(),
    );
  }
}
