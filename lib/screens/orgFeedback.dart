import "package:flutter/material.dart";
import "package:fido_project/constants/constantsVariable.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrgFeedback extends StatefulWidget {
  String donation_boxID;

  OrgFeedback({Key key, this.donation_boxID}) : super(key: key);
  @override
  _OrgFeedbackState createState() => _OrgFeedbackState(this.donation_boxID);
}

class _OrgFeedbackState extends State<OrgFeedback> {
  String donation_boxID;
  _OrgFeedbackState(this.donation_boxID);
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController feedback = TextEditingController();

  Future orgFeedback() async {
    print("click feedback");
    if (_formKey.currentState.validate()) {
      var response = await http.post(
          "http://192.168.254.106/phpPractice/mobile/orgFeedbackApi.php",
          body: {
            'orgfeedback': feedback.text,
            'orgdonation_boxID': donation_boxID
          });
      var data = json.decode(response.body);
      if (data == "Success") {
        Fluttertoast.showToast(
            msg: "Message Sent Successfully",
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
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kprimaryColor,
          title: Text("Organization Feedback"),
        ),
        body: Container(
          margin: EdgeInsets.all(24),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                      controller: feedback,
                      maxLines: 5,
                      decoration:
                          InputDecoration(hintText: "Input your feedback")),
                  SizedBox(
                    width: double.infinity,
                    child: ButtonTheme(
                      height: 50.0,
                      child: RaisedButton(
                          onPressed: () {
                            orgFeedback();
                          },
                          color: ksecondaryColor,
                          child: Text("Send Feedback",
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                ],
              )),
        ));
  }
}
