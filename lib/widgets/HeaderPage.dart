import 'package:flutter/material.dart';

AppBar header(context,
    {bool isAppTitle = false,
    String strTitle,
    bool disableBackButton = false}) {
  return AppBar(
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      title: Text(
        isAppTitle ? "Instagram" : strTitle,
        style: TextStyle(
            color: Colors.white, fontSize: 40, fontFamily: "Signatra"),
        overflow: TextOverflow.clip,
      ),
      centerTitle: true,
      automaticallyImplyLeading: disableBackButton ? false : true);
}
