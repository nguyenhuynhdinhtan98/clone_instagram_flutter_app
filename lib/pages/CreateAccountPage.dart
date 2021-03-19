import 'package:flutter/material.dart';

class CreateAccountPage extends StatefulWidget {
  @override
  _CreateAccountPageState createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  final _formGlobalKey = GlobalKey<FormState>();

  String userName;

  submitUserName() {
    final form = _formGlobalKey.currentState;

    if (form.validate()) {
      form.save();
      SnackBar snackBar = SnackBar(content: Text("Welcome " + userName.trim()));
      _scaffoldGlobalKey.currentState.showSnackBar(snackBar);
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pop(context, userName);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Form(
              key: _formGlobalKey,
              autovalidate: true,
              child: TextFormField(
                style: TextStyle(color: Colors.black),
                onChanged: (val) => userName = val,
                onSaved: (val) => userName = val,
                decoration: InputDecoration(
                    labelText: "User Name",
                    labelStyle: TextStyle(fontSize: 15),
                    hintText: "Must have at least 5 characters",
                    hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                    border: OutlineInputBorder(),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey))),
                validator: (val) {
                  if (val.trim().length < 5) {
                    return "User Name is very short";
                  } else if (val.trim().length > 15) {
                    return "User Name is very long";
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 25.0,
            ),
            GestureDetector(
                onTap: submitUserName,
                child: Container(
                    decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Center(
                        child: Text(
                          "Register",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )))
          ],
        ),
      ),
    );
  }
}
