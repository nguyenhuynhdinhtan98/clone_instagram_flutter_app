import 'package:clone_instagram_flutter_app/pages/CreateAccountPage.dart';
import 'package:clone_instagram_flutter_app/pages/TimeLinePage.dart';
import 'package:clone_instagram_flutter_app/pages/SearchPage.dart';
import 'package:clone_instagram_flutter_app/pages/UploadPage.dart';
import 'package:clone_instagram_flutter_app/pages/NotificationsPage.dart';
import 'package:clone_instagram_flutter_app/pages/ProfilePage.dart';
import 'package:clone_instagram_flutter_app/models/user.dart' as UserModal;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = GoogleSignIn();
final usersReference = FirebaseFirestore.instance.collection("users");
final DateTime timestamp = DateTime.now();

UserModal.User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController;
  bool isSignedIn = false;
  int pageIndex;

  @override
  void initState() {
    super.initState();
    pageIndex = 2;
    pageController = PageController(initialPage: pageIndex, keepPage: true);
    //check auth when auth change
    _googleSignIn.onCurrentUserChanged.listen((signInAccount) {
      _controlSignIn(signInAccount);
    }, onError: (error) {
      print(error);
    });
    // check auth when open app
    _googleSignIn
        .signInSilently(suppressErrors: false)
        .then((signInAccount) => _controlSignIn(signInAccount))
        .catchError((error) {
      print(error);
    });
  }

  void _controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await saveDataUserInfor();
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  saveDataUserInfor() async {
    final GoogleSignInAccount _googleSignInAccout = _googleSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.doc(_googleSignInAccout.id).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));

      print(_googleSignInAccout);
      await usersReference.doc(_googleSignInAccout.id).set({
        "id": _googleSignInAccout.id,
        "profile_name": _googleSignInAccout.displayName,
        "user_name": username,
        "url": _googleSignInAccout.photoUrl,
        "email": _googleSignInAccout.email,
        "bio": "",
        "time_stamp": timestamp
      });
      documentSnapshot = await usersReference.doc(_googleSignInAccout.id).get();
    }
    currentUser = UserModal.User.fromDocument(documentSnapshot);
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

  whenPageChange(int index) {
    setState(() {
      this.pageIndex = index;
    });
  }

  onTapChangePage(int index) {
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Scaffold buildHomeScreen() {
    return Scaffold(
      body: PageView(
        children: [
          SearchPage(),
          UploadPage(),
          TimeLinePage(),
          NotificationsPage(),
          ProfilePage()
        ],
        controller: pageController,
        onPageChanged: whenPageChange,
        physics: RangeMaintainingScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: pageIndex,
        onTap: onTapChangePage,
        backgroundColor: Theme.of(context).primaryColor,
        activeColor: Colors.white,
        inactiveColor: Colors.black,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.search)),
          BottomNavigationBarItem(icon: Icon(Icons.photo_camera)),
          BottomNavigationBarItem(
              icon: Icon(
            Icons.home,
            size: 35,
          )),
          BottomNavigationBarItem(icon: Icon(Icons.notifications)),
          BottomNavigationBarItem(icon: Icon(Icons.person))
        ],
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }
}
