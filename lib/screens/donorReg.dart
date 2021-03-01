import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fido_project/screens/donorLogin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _fullname = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController _contact = TextEditingController();
  TextEditingController _password = TextEditingController();
  int donortype = 1;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//regex
  setSelectedRadio(int val) {
    setState(() {
      donortype = val;
    });
  }

  final ageReg = RegExp(r'^[0-9]*$');
  Future register() async {
    if (_formKey.currentState.validate()) {
      var url = "http://192.168.254.106/phpPractice/mobile/registerapi.php";
      //online api
      // var url = "https://fidoproject.000webhostapp.com/api.php";
      var response = await http.post(url, body: {
        "fullname": _fullname.text,
        "address": _address.text,
        "username": _username.text,
        "email": _email.text,
        "age": _age.text,
        "contact": _contact.text,
        "password": _password.text,
        "donortype": donortype.toString(),
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

  Widget _buildfullnameField() {
    return TextFormField(
        controller: _fullname,
        decoration: InputDecoration(labelText: "Name"),
        validator: (e) => e.isEmpty ? "Please input fullname" : null);
  }

  Widget _buildusernameField() {
    return TextFormField(
      controller: _username,
      decoration: InputDecoration(labelText: "Username"),
      validator: (e) => e.isEmpty ? "Please input username" : null,
    );
  }

  Widget _buildaddressField() {
    return TextFormField(
      controller: _address,
      decoration: InputDecoration(labelText: "Address"),
      validator: (e) => e.isEmpty ? "Please input address" : null,
    );
  }

  Widget _buildemailField() {
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      controller: _email,
      decoration: InputDecoration(labelText: "Email"),
      validator: (e) => e.isEmpty ? "Please input email" : null,
    );
  }

  Widget _buildageField() {
    return TextFormField(
        controller: _age,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: "Age"),
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
        ],
        validator: (e) => e.isEmpty ? "Please input a age" : null);
  }

  Widget _buildcontactField() {
    return TextFormField(
      controller: _contact,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: "Contact"),
      validator: (e) => e.isEmpty ? "Please input contact" : null,
    );
  }

  Widget _buildpasswordField() {
    return TextFormField(
      controller: _password,
      obscureText: true,
      decoration: InputDecoration(labelText: "Password"),
      validator: (e) => e.isEmpty ? "Please input password" : null,
    );
  }

  Widget _buildconfirmpasswordField() {
    return TextFormField(
        obscureText: true,
        decoration: InputDecoration(labelText: "Confirm Password"),
        validator: (e) {
          if (e != _password.text) {
            return "Password do not match";
          }
          if (e.isEmpty) {
            return "Invalid password";
          }
          return null;
        });
  }

  Widget _builddonortypeField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Individual'),
        Radio(
            value: 1,
            groupValue: donortype,
            activeColor: Colors.green,
            onChanged: (val) {
              print("Radio $val");
              setSelectedRadio(val);
            }),
        Text('Organization'),
        Radio(
            value: 2,
            groupValue: donortype,
            activeColor: Colors.green,
            onChanged: (val) {
              print("Radio $val");
              setSelectedRadio(val);
            }),
      ],
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
                    _buildfullnameField(),
                    _buildaddressField(),
                    _buildusernameField(),
                    _buildemailField(),
                    _buildageField(),
                    _buildcontactField(),
                    _buildpasswordField(),
                    _buildconfirmpasswordField(),
                    SizedBox(height: 20.0),
                    Text("I am an "),
                    _builddonortypeField(),
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
                            register();
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
