import 'package:fido_project/constants/constantsVariable.dart';
import "package:flutter/material.dart";
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrgAccount extends StatefulWidget {
  @override
  _OrgAccountState createState() => _OrgAccountState();
}

class _OrgAccountState extends State<OrgAccount> {
  String _username = "";
  Future getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _username = preferences.getString('orgname');
    });
  }

  // void changePassword() async {
  //   var url = "http://$myip/phpPractice/mobile/updateOrgAccountApi.php";
  //   var response = await http.post(url,
  //       body: {"orgusername": _username, "orgpassword": orgpassword});
  // }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Account"), backgroundColor: kprimaryColor),
        body: Container(
            child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(children: [
            TextFieldReusable(name: "Current Password"),
            TextFieldReusable(name: "Change Password"),
            RaisedButton(
                color: kprimaryColor,
                onPressed: () {
                  // changePassword();
                },
                child: Text("Change Password",
                    style: TextStyle(color: Colors.white)))
          ]),
        )));
  }
}

class TextFieldReusable extends StatelessWidget {
  final String name;
  final String myValue;
  TextFieldReusable({this.name, this.myValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: myValue,
        decoration: InputDecoration(
          labelText: name,
        ));
  }
}
