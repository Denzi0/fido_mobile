import 'dart:math';

import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fido_project/screens/donorLogin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class RegisterOrg extends StatefulWidget {
  @override
  _RegisterOrgState createState() => _RegisterOrgState();
}

class _RegisterOrgState extends State<RegisterOrg> {
  TextEditingController _organizationname = TextEditingController();

  TextEditingController _personInCharge = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _website = TextEditingController();

  TextEditingController _email = TextEditingController();
  TextEditingController _tinNo = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ageReg = RegExp(r'^[0-9]*$');

  // generate random password
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  //
  Future registerOrg() async {
    if (_formKey.currentState.validate()) {
      var url = "http://$myip/phpPractice/mobile/registerorgapi.php";

      var response = await http.post(url, body: {
        // "fullname": _fullname.text,
        "orgname": _organizationname.text,
        "personInCharge": _personInCharge.text,
        "contact": _contact.text,
        "address": _address.text,
        "website": _website.text,
        "email": _email.text,
        "tinNumber": _tinNo.text,
        "randompassword": generateRandomString(5)
      });
      var data = json.decode(response.body);
      if (data == "Error") {
        Fluttertoast.showToast(
            msg: "This User Already Exist",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: kprimaryColor,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Successfully Registered",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    }
  }

  Widget _buildorganizationnameField() {
    return TextFormField(
      controller: _organizationname,
      decoration: InputDecoration(labelText: "Organization Name"),
      validator: (e) => e.isEmpty ? "Please input value" : null,
    );
  }

  Widget _buildpersonInChargeField() {
    return TextFormField(
      controller: _personInCharge,
      decoration: InputDecoration(labelText: "Person in Charge"),
      validator: (e) => e.isEmpty ? "Please input value" : null,
    );
  }

  Widget _buildcontactField() {
    return TextFormField(
      // keyboardType: TextInputType.emailAddress,
      controller: _contact,
      decoration: InputDecoration(labelText: "Contact"),
      validator: (e) => e.isEmpty ? "Please input value" : null,
    );
  }

  Widget _buildaddressField() {
    return TextFormField(
        controller: _address,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "Address"),
        validator: (e) => e.isEmpty ? "Please input a value" : null);
  }

  Widget _buildwebsiteField() {
    return TextFormField(
      controller: _website,
      // obscureText: true,
      decoration: InputDecoration(labelText: "Website"),
      validator: (e) => e.isEmpty ? "Please input value" : null,
    );
  }

  Widget _buildemailField() {
    return TextFormField(
      controller: _email,
      // obscureText: true,
      decoration: InputDecoration(labelText: "Email"),
      validator: (e) => e.isEmpty ? "Please input value" : null,
    );
  }

  Widget _buildtinNoField() {
    return TextFormField(
      controller: _tinNo,
      // obscureText: true,
      decoration: InputDecoration(labelText: "Tin Number"),
      validator: (e) => e.isEmpty ? "Please input value" : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kprimaryColor,
        title: Text("Registration"),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 24.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // _buildfullnameField(),
                    _buildorganizationnameField(),
                    _buildpersonInChargeField(),
                    _buildcontactField(),
                    _buildaddressField(),
                    _buildwebsiteField(),
                    _buildtinNoField(),
                    _buildemailField(),
                    SizedBox(height: 20.0),

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
                            'Sign Up',
                            style: TextStyle(fontSize: 16),
                          ),
                          onPressed: () {
                            registerOrg();
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      Text("I already have an account ?"),
                      GestureDetector(
                        child: Text(
                          " Click here",
                          style: TextStyle(color: kprimaryColor),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                    ])
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
