import 'package:clone_instagram_flutter_app/pages/HomePage.dart';
import 'package:clone_instagram_flutter_app/pages/NotificationsPage.dart';
import 'package:clone_instagram_flutter_app/pages/ProfilePage.dart';
import 'package:clone_instagram_flutter_app/pages/SearchPage.dart';
import 'package:clone_instagram_flutter_app/pages/TimeLinePage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
