import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final usersReference = FirebaseFirestore.instance.collection("users");

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _googleSignIn.onCurrentUserChanged.listen((event) {
      _controlSignIn(event);
    });
  }

  void _controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  void _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  void _handleSignOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (error) {
      print(error);
    }
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Instagram",
              style: TextStyle(fontSize: 70, fontFamily: "Signatra"),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: GestureDetector(
                onTap: () async {
                  await _handleSignIn();
                },
                child: Image.asset("assets/images/google_signin_button.png",
                    fit: BoxFit.contain),
              ),
            )
          ],
        ),
      ),
    );
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FlatButton(
              onPressed: () {
                _handleSignOut();
              },
              child: Text(
                "Sign Out",
                style: TextStyle(fontSize: 70),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}
