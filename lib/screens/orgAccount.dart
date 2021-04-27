import 'package:fido_project/constants/constantsVariable.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrgAccount extends StatefulWidget {
  @override
  _OrgAccountState createState() => _OrgAccountState();
}

class _OrgAccountState extends State<OrgAccount> {
  String _orgUname = "";

  TextEditingController currentPass = new TextEditingController();
  TextEditingController changePass = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _orgUname = preferences.getString('orgname');
    });
  }

  void changePassword() async {
    if (_formKey.currentState.validate()) {
      print("hellow");
      var url = "http://$myip/phpPractice/mobile/orgChangePassApi.php";
      var response = await http.post(url, body: {
        "orgusername": _orgUname,
        "orgOldpassword": currentPass.text,
        "orgNewpassword": changePass.text,
      });

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
          child: Form(
            key: _formKey,
            child: Column(children: [
              // TextFieldReusable(controllerName: orgnameController),
              // TextFieldReusable(
              //     name: "Current Password", controllerName: currentPass),
              TextFieldReusable(
                  name: "Change Password", controllerName: changePass),
              RaisedButton(
                  color: kprimaryColor,
                  onPressed: () {
                    changePassword();
                  },
                  child: Text("Change Password",
                      style: TextStyle(color: Colors.white)))
            ]),
          ),
        )));
  }
}

class TextFieldReusable extends StatelessWidget {
  final String name;
  final TextEditingController controllerName;
  TextFieldReusable({this.name, this.controllerName});

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
        obscureText: true,
        controller: controllerName,
        decoration: InputDecoration(
          labelText: name,
        ));
  }
}
