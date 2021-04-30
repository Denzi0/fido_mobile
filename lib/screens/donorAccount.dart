import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:fido_project/constants/constantsVariable.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _donorUname = "";

  TextEditingController _currentPass = new TextEditingController();
  TextEditingController _changePass = new TextEditingController();
  TextEditingController _donorUsername;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _donorUname = preferences.getString('username');
      _donorUsername = TextEditingController(text: _donorUname);
    });
  }

  void changeProfile() async {
    if (_formKey.currentState.validate()) {
      print("hellow donor");

      var url = "http://$myip/phpPractice/mobile/donorChangePassApi.php";
      var response = await http.post(url, body: {
        "donorusername": _donorUsername.text,
        "donorOldpassword": _currentPass.text,
        "donorNewpassword": _changePass.text,
      });
      print(_donorUname);
      print(_changePass.text);
      var data = json.decode(response.body);
      if (data == "Success") {
        Fluttertoast.showToast(
            msg: "Password Change",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

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
            child: Form(
              key: _formKey,
              child: Column(children: [
                TextFieldReusable(
                    name: "Username",
                    controllerName: _donorUsername,
                    isObscureText: false),
                TextFieldReusable(
                    name: "Change Password",
                    controllerName: _changePass,
                    isObscureText: true),
                RaisedButton(
                    color: kprimaryColor,
                    onPressed: () {
                      changeProfile();
                    },
                    child: Text("Change Password",
                        style: TextStyle(color: Colors.white)))
              ]),
            ),
          ),
        ));
  }
}

class TextFieldReusable extends StatelessWidget {
  final bool isObscureText;
  final String name;
  final TextEditingController controllerName;
  TextFieldReusable({this.name, this.controllerName, this.isObscureText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        validator: (e) {
          if (e.isEmpty) {
            return "Please input Field";
          } else {
            return null;
          }
        },
        obscureText: isObscureText,
        controller: controllerName,
        decoration: InputDecoration(
          labelText: name,
        ));
  }
}
