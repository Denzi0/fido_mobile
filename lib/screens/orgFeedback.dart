import "package:flutter/material.dart";
import "package:fido_project/constants/constantsVariable.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class OrgFeedback extends StatefulWidget {
  String donation_boxID;

  OrgFeedback({Key key, this.donation_boxID}) : super(key: key);
  @override
  _OrgFeedbackState createState() => _OrgFeedbackState(this.donation_boxID);
}

class _OrgFeedbackState extends State<OrgFeedback> {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

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
      var data = await json.decode(response.body);
      if (data == "Success") {
        // showNotification();
        Fluttertoast.showToast(
            msg: "Message Sent Successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  // Future click() async {
  //   var response =
  //       await http.post('http://192.168.254.106/phpPractice/mobile/sample.php');
  //   print("here================");
  //   var convert = json.decode(response.body);
  //   var convert2 = convert.where((i) => i['orgName'] == 'Alay lakad').toList();
  //   print(convert2);
  //   if (true) {
  //     for (var i = 0; i <= convert2.length - 1; i++) {
  //       print("printed ${convert2[i]['statusDescription']}");
  //     }
  //   } else {
  //     print("no mesage");
  //   }
  // }

  @override
  void initState() {
    super.initState();

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var ios = IOSInitializationSettings();
    var initialize = InitializationSettings(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.initialize(initialize,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint("Notification : " + payload);
    }
  }

  Future showNotification(data) async {
    var android = AndroidNotificationDetails(
        'channelId', 'channelName', 'channelDescription');
    var ios = IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: ios);
    flutterLocalNotificationsPlugin.show(0, data, 'body', platform,
        payload: 'some details');
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
                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ButtonTheme(
                  //     height: 50.0,
                  //     child: RaisedButton(
                  //         onPressed: () {
                  //           click();
                  //         },
                  //         color: ksecondaryColor,
                  //         child: Text("Click",
                  //             style: TextStyle(color: Colors.white))),
                  //   ),
                  // ),
                ],
              )),
        ));
  }
}
