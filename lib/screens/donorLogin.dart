import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fido_project/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:fido_project/constants/constantsVariable.dart';
import 'package:fido_project/screens/donorReg.dart';
import 'package:fido_project/screens/orgLogin.dart';
import 'package:fido_project/screens/donorForgotpassword.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //////

  //////////
  bool isObscure = true;
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  void toggleVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  Future login() async {
    if (_formKey.currentState.validate()) {
      var url = "http://192.168.254.106/phpPractice/mobile/loginapi.php";
      var response = await http.post(url,
          body: {'username': _username.text, 'password': _password.text});
      var data = json.decode(response.body);
      if (data == "Success") {
        // SharedPreferences logout and keep login in
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('username', _username.text);
        // Up to here
        Fluttertoast.showToast(
            msg: "Successfully Login",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Welcome()));
      } else {
        Fluttertoast.showToast(
            msg: "Invalid Username or Password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Widget _buildLoginInputField(
      {String label,
      TextEditingController name,
      IconData iconShow,
      IconData iconHide}) {
    return TextFormField(
      controller: name,
      obscureText: label == "Password" ? isObscure : false,
      decoration: InputDecoration(
          suffixIcon: InkWell(
              onTap: toggleVisibility,
              child: isObscure ? Icon(iconShow) : Icon(iconHide)),
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
                  _buildLoginInputField(label: "Username", name: _username),
                  SizedBox(height: 15),
                  _buildLoginInputField(
                      label: "Password",
                      name: _password,
                      iconShow: Icons.visibility,
                      iconHide: Icons.visibility_off),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 3, top: 3),
                          child: GestureDetector(
                            child: Text(
                              "Forgot Password ?",
                              style: TextStyle(color: Color(0xff5b5b5b)),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DonorForgotPass()));
                            },
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/first');
                          print("hellow");
                        },
                      )
                    ],
                  ),
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
                          login();
                          print('login');
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Text("Don't Have an Account ?",
                        style: TextStyle(color: Color(0xff5b5b5b))),
                    GestureDetector(
                      child: Text(
                        "  Click here",
                        style: TextStyle(color: kprimaryColor),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register()));
                      },
                    ),
                  ]),
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
                          'Login with your Organization',
                          style: TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrgLogin()));
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
      ),
    );
  }
}

// class LoginInputField extends StatelessWidget {
//   final TextEditingController name;
//   final bool isObscure;
//   final String label;
//   final String errorLabel;
//   final IconData inkIcon;

//   LoginInputField(
//       {this.name, this.isObscure, this.label, this.errorLabel, this.inkIcon});
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: name,
//       obscureText: isObscure,
//       decoration: InputDecoration(
//           suffixIcon: InkWell(
//               onTap: () {

//               },
//               child: Icon(inkIcon)),
//           labelText: label,
//           border: OutlineInputBorder()),
//       validator: (e) => e.isEmpty ? errorLabel : null,
//     );
//   }
// }
