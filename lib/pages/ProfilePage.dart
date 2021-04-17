import 'package:clone_instagram_flutter_app/pages/HomePage.dart';
import 'package:clone_instagram_flutter_app/widgets/HeaderPage.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  String userProfileId;
  ProfilePage({this.userProfileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser?.id;
  int countPost = 0;
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;
  Column createColumns(String title, int count) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          count.toString(),
          style: TextStyle(
              fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: EdgeInsets.only(top: 5.0),
          child: Text(
            title,
            style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  Container createButtonTitleAndFunction(
      {String title, Function performFunction}) {
    return Container(
      child: FlatButton(
        onPressed: performFunction,
        child: Container(
          child: Text(
            title,
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(6.0),
          ),
        ),
      ),
    );
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return createButtonTitleAndFunction(
        title: "Edit Profile",
        // performFunction: editUserProfile,
      );
    } else if (following) {
      return createButtonTitleAndFunction(
        title: "Unfollow",
        // performFunction: controlUnfollowUser,
      );
    } else if (!following) {
      return createButtonTitleAndFunction(
        title: "Follow",
        // performFunction: controlFollowUser,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(
        context,
        strTitle: "Profile Page",
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  child: ClipOval(
                    child: Image.network(
                      "https://firebasestorage.googleapis.com/v0/b/instagram-clone-90efb.appspot.com/o/Picture%2Fpost_76c7c426-3b2c-4213-bf8f-b8297ac53d85.jpg?alt=media&token=1f976b81-94b2-41a6-acc6-0768d5a2a2db",
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          createColumns("posts", countPost),
                          createColumns("followers", countTotalFollowers),
                          createColumns("following", countTotalFollowings),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          createButton(),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
    
  }
}
