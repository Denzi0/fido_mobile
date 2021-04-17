import 'package:fido_project/constants/appNames.dart';
import 'package:flutter/material.dart';
import 'package:fido_project/constants/constantsVariable.dart';

import 'package:fido_project/screens/donorLogin.dart';
import 'package:fido_project/screens/orgmenu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrgLogin extends StatefulWidget {
  @override
  _OrgLoginState createState() => _OrgLoginState();
}

class _OrgLoginState extends State<OrgLogin> {
  var orgname;
  bool _isObscure = true;
  TextEditingController _orgname = TextEditingController();
  TextEditingController _orgpassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void _toggleVisibility() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  Future orglogin() async {
    if (_formKey.currentState.validate()) {
      var url = "http://$myip/phpPractice/mobile/orgloginapi.php";
      var response = await http.post(url,
          body: {'orgname': _orgname.text, 'orgpassword': _orgpassword.text});
      var data = json.decode(response.body);
      if (data == "Success") {
        // SharedPreferences logout and keep login in
        SharedPreferences preferences = await SharedPreferences.getInstance();
        orgname = preferences.setString('orgname', _orgname.text);
        // Up to here
        Fluttertoast.showToast(
            msg: "Successfully Login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WelcomeOrg(orgUsername: _orgname.text)));
      } else {
        Fluttertoast.showToast(
            msg: "Invalid Credentials",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Widget _buildOrgLoginInputField(
      {String label,
      TextEditingController name,
      IconData iconShow,
      IconData iconHide}) {
    return TextFormField(
      controller: name,
      obscureText: label == "Password" ? _isObscure : false,
      decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: _toggleVisibility,
              child: _isObscure ? Icon(iconShow) : Icon(iconHide)),
          labelText: label,
          border: OutlineInputBorder()),
      validator: (e) => e.isEmpty ? "Please Input Field" : null,
    );
  }

  //this is text widget

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xfff8f1f1),
        // resizeToAvoidBottomPadding: false,
        body: Container(
          margin: EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/images/appName.png', height: 100, width: 100),
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildOrgLoginInputField(
                        label: "Organization name", name: _orgname),
                    SizedBox(height: 15),
                    _buildOrgLoginInputField(
                        label: "Password",
                        name: _orgpassword,
                        iconShow: Icons.visibility,
                        iconHide: Icons.visibility_off),

                    //sample
                    //sample
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonTheme(
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: kprimaryColor,
                          textColor: Colors.white,
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            orglogin();
                            print('login');
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              indent: 10.0,
                              color: Color(0xff5b5b5b),
                              height: 50.0,
                            )),
                      ),
                      Text("OR",
                          style: TextStyle(
                              fontSize: 16.0, color: Color(0xffd9d9d9))),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Color(0xff5b5b5b),
                              height: 50.0,
                              endIndent: 10.0,
                            )),
                      ),
                    ]),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonTheme(
                        height: 50,
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          color: kprimaryColor,
                          textColor: Colors.white,
                          child: Text(
                            'Login in as Donor',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Login()));
                            print('login with org');
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
