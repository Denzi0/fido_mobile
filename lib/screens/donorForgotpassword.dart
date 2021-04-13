import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';
import 'package:fido_project/constants/constantsVariable.dart';

class DonorForgotPass extends StatefulWidget {
  @override
  _DonorForgotPassState createState() => _DonorForgotPassState();
}

class _DonorForgotPassState extends State<DonorForgotPass> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool verifyButton = false;
  String verifyLink;
  Future checkUser() async {
    var url = "http://$myip/phpPractice/mobile/donorPassCheck.php";
    var response = await http.post(url, body: {
      'donoremail': email.text,
    });
    var link = json.decode(response.body);

    if (link == "Invalid") {
      Fluttertoast.showToast(
          msg: "This User is not in our database",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 4,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      setState(() {
        verifyLink = link;
        verifyButton = true;
      });
      sendMail();
      // Fluttertoast.showToast(
      //     msg: "Click Reset Password",
      //     toastLength: Toast.LENGTH_LONG,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 3,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
    }
    print(link);
  }

  int newPass = 0;
  Future resetPassword() async {
    var response = await http.post(verifyLink);
    var link = json.decode(response.body);
    print(link);
    setState(() {
      newPass = link;
      verifyButton = false;
    });
    print(link);
    // Fluttertoast.showToast(
    //     msg: "Reset Password",
    //     toastLength: Toast.LENGTH_LONG,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 3,
    //     backgroundColor: Colors.red,
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  void validate() {
    if (_formKey.currentState.validate()) {
      resetPassword();
    }
  }

  sendMail() async {
    String username = email.text;
    // String password = "";
    final smtpServer = gmail(username, password.text);
    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer forganization further configuration
    // options.

    // Create our message.
    final message = Message()
      ..from = Address(username, 'noreply')
      ..recipients.add(username)
      // ..ccRecipients.addAll(['destCc1@example.com', 'destCc2@example.com'])
      // ..bccRecipients.add(Address('bccAddress@example.com'))
      ..subject = '$username ${DateTime.now()}'
      // ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html =
          "<p>Hello <b>$username</b></p>\n<p>Hello User Your password reset has been confirmed New Password : $newPass\n<a href='$verifyLink'>Click Here</a></p>";

    try {
      final sendReporganizationt = await send(message, smtpServer);
      print('Message Sent Successfully : ' + sendReporganizationt.toString());

      ///
      Fluttertoast.showToast(
          msg: "Message Sent Successfully",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);

      ///
    } on MailerException catch (e) {
      print('Message not sent.');
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Forgot Password"), backgroundColor: kprimaryColor),
      body: SafeArea(
        child: Container(
            margin: EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      validator: (e) =>
                          e.isEmpty ? "Please Enter Your Email" : null,
                      controller: email,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Gmail")),
                  SizedBox(height: 10),
                  TextFormField(
                      validator: (e) =>
                          e.isEmpty ? "Please Enter Email Password" : null,
                      controller: password,
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Email Password")),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Container(
                      margin: EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                          onPressed: () {
                            validate();
                            checkUser();
                          },
                          child: Text("Recover Password"),
                          textColor: Colors.white,
                          color: Colors.blue),
                    ),
                    verifyButton
                        ? RaisedButton(
                            onPressed: () {
                              resetPassword();
                            },
                            child: Text("Reset"),
                            textColor: Colors.white,
                            color: Colors.red,
                          )
                        : Container()
                  ])
                ],
              ),
            )),
      ),
    );
  }
}
