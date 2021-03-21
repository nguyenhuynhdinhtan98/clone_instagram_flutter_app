import 'dart:convert';
import 'package:clone_instagram_flutter_app/models/user.dart';
import 'package:clone_instagram_flutter_app/pages/HomePage.dart';
import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:clone_instagram_flutter_app/widgets/ProgressWidget.dart';
import 'package:clone_instagram_flutter_app/pages/ProfilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textEditingController = TextEditingController();
  Future<QuerySnapshot> futureBuilder;
  clearSearch() {
    textEditingController.clear();
  }

  controlSearching(String str) {
    Future<QuerySnapshot> allUsers =
        usersReference.where("profile_name", isGreaterThanOrEqualTo: str).get();
    setState(() {
      futureBuilder = allUsers;
    });
  }

  Container displaySearchBar() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.5)
          ]),
      child: TextFormField(
          textAlignVertical: TextAlignVertical.center,
          onChanged: controlSearching,
          controller: textEditingController,
          style: TextStyle(color: Colors.black),
          decoration: InputDecoration(
            isDense: true,
            hintText: "Search Here",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: InputBorder.none,
            filled: true,
            prefixIcon: Icon(
              Icons.person_pin,
              color: Colors.grey,
              size: 30,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.grey,
                size: 30,
              ),
              onPressed: clearSearch,
            ),
          )),
    );
  }

  displayListUser() {
    return FutureBuilder(
        future: futureBuilder,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
              flex: 1,
              child: Center(
                child: circularProgress(),
              ),
            );
          }

          List<UserResult> searchUsersResult = [];
          snapshot.data.docs.forEach((DocumentSnapshot document) {
            User eachUser = User.fromDocument(document);
            UserResult userResult = UserResult(eachUser);
            searchUsersResult.add(userResult);
          });
          return Expanded(
              flex: 1, child: ListView(children: searchUsersResult));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        strTitle: "Search Page",
      ),
      body: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [displaySearchBar(), displayListUser()],
          )),
    );
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(color: Colors.grey, blurRadius: 2.0, spreadRadius: 0.5)
            ]),
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () =>
                  displayUserProfile(context, userProfileId: eachUser.id),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(
                  eachUser.profileName,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  eachUser.username,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 13.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  displayUserProfile(BuildContext context, {String userProfileId}) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ProfilePage(userProfileId: userProfileId)));
  }
}
