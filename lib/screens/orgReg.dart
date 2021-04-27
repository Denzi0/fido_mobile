import 'dart:io';
import 'dart:math';

import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fido_project/screens/donorLogin.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

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
  File _file;
  // generate random password
  String generateRandomString(int len) {
    var r = Random();
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  void _uploadFile(_file) {}
  // String orgrandompassword = generateRandomString(5);
  //
  Future registerOrg() async {
    if (_formKey.currentState.validate()) {
      String orgrandompassword = generateRandomString(5);
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
        "randompassword": orgrandompassword
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
        String username = 'denzellanzaderas@gmail.com';
        String password = 'denziolanzx44';

        final smtpServer = gmail(username, password);
        // Use the SmtpServer class to configure an SMTP server:
        // final smtpServer = SmtpServer('smtp.domain.com');
        // See the named arguments of SmtpServer for further configuration
        // options.

        // Create our message.
        final message = Message()
          ..from = Address(username, 'Food and Item Donation Tracking Sytem')
          ..recipients.add('${_email.text}')
          // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
          // ..bccRecipients.add(Address('bccAddress@example.com'))
          ..subject = 'Test Dart Mailer library ::  :: ${DateTime.now()}'
          ..text = 'This is the plain text.\nThis is line 2 of the text part.'
          ..html =
              "<h3>Thank you for registering . Below is your login credentials</h3>\n<p></p>Username : ${_organizationname.text}<p>Password : $orgrandompassword</p>";

        try {
          final sendReport = await send(message, smtpServer);
          print('Message sent: ' + sendReport.toString());
        } on MailerException catch (e) {
          print('Message not sent.');
          for (var p in e.problems) {
            print('Problem: ${p.code}: ${p.msg}');
          }
        }

        Fluttertoast.showToast(
            msg: "Successfully Registered Message sent via Email",
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
                    RaisedButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        color: kprimaryColor,
                        textColor: Colors.white,
                        child: Text("Upload File"),
                        onPressed: () {
                          _uploadFile(_file);
                        }),
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

  /////////widgets inputs

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

  String validateContact(String value) {
    Pattern pattern = r"^(09|\+639)\d{9}$";

    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid phone number';
    else
      return null;
  }

  Widget _buildcontactField() {
    return TextFormField(
        maxLength: 11,

        // keyboardType: TextInputType.emailAddress,
        controller: _contact,
        decoration: InputDecoration(labelText: "Contact"),
        validator: validateContact);
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

  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  String validateEmailOrg(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  Widget _buildemailField() {
    return TextFormField(
      controller: _email,
      // obscureText: true,
      decoration: InputDecoration(labelText: "Email"),
      validator: validateEmailOrg,
    );
  }

  Widget _buildtinNoField() {
    return TextFormField(
      maxLength: 9,

      controller: _tinNo,
      // obscureText: true,
      decoration: InputDecoration(labelText: "Tin Number"),
      validator: (e) => e.isEmpty ? "Please input value" : null,
    );
  }
}
