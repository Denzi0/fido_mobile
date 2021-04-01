import 'package:fido_project/screens/donorLogin.dart';
import 'package:fido_project/screens/donorProfile.dart';
import 'package:fido_project/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';
import 'dart:async';

const simplePeriodicTask = "simplePeriodicTask";
// flutter local notification setup

var username;
void showNotification(id, v, y, flp) async {
  var android = AndroidNotificationDetails(
      'ChannelID', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(id, '$y', '$v', platform, payload: 'VIS \n $v');
}

void main() async {
  //Flutter sessions
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher,
      isInDebugMode:
          true); //to true if still in testing lev turn it to false whenever you are launching the app
  await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15), //when should it check the link
      initialDelay:
          Duration(seconds: 5), //duration before showing the notification
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));
  SharedPreferences preferences = await SharedPreferences.getInstance();
  username = preferences.getString('username');

  // the Shared preferences
  runApp(MaterialApp(home: username == null ? Login() : Welcome()));
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);

    var response =
        await http.post('http://192.168.254.106/phpPractice/mobile/sample.php');
    var convert = json.decode(response.body);
    print(convert);

    if (true) {
      for (var i = 0; i <= convert.length; i++) {
        showNotification(
            i,
            "Donation Status ${convert[i]['statusDescription']}",
            "Your donation from ${convert[i]['orgName']}${convert[i]['donation_boxID']}",
            flp);
      }
    } else {
      print("no messagge");
    }

    return Future.value(true);
  });
}

//  token != '' ? DonorProfile() :
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   //flutterSessions
//   // dynamic token = FlutterSession().get('token');
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(home: username == null ? Login() : Welcome());
//   }
// }
// token != '' ? Welcome() :

// class _MyAppState extends State<MyApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(initialRoute: '/', routes: {
//       '/': (context) => Login(),
//       '/first': (context) => Register(),
//       '/second': (context) => Welcome(),
//       '/third': (context) => DonationCategory(),
//       '/four': (context) => Food(),
//     });
//   }
// }
