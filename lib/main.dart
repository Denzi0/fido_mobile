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

String username;
String orgname;
// void showNotification(id, v, y, flp) async {
//   var android = AndroidNotificationDetails(
//       'ChannelID', 'channel NAME', 'CHANNEL DESCRIPTION',
//       priority: Priority.high, importance: Importance.max);
//   var iOS = IOSNotificationDetails();
//   var platform = NotificationDetails(android: android, iOS: iOS);
//   await flp.show(id, '$y', '$v', platform, payload: 'VIS \n $v');
// }

void main() async {
  //Flutter sessions
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  username = preferences.getString('username');
  orgname = preferences.getString('orgname');
  // await Workmanager.initialize(callbackDispatcher,
  //     isInDebugMode:
  //         true); //to true if still in testing lev turn it to false whenever you are launching the app
  // await Workmanager.registerPeriodicTask("5", simplePeriodicTask,
  //     existingWorkPolicy: ExistingWorkPolicy.replace,
  //     frequency: Duration(minutes: 15), //when should it check the link
  //     initialDelay:
  //         Duration(seconds: 5), //duration before showing the notification
  //     constraints: Constraints(
  //       networkType: NetworkType.connected,
  //     ));

  // the Shared preferences
  runApp(MaterialApp(home: username == null ? Login() : Welcome()));
}

// void callbackDispatcher() {
//   Workmanager.executeTask((task, inputData) async {
//     FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
//     var android = AndroidInitializationSettings('@mipmap/ic_launcher');
//     var iOS = IOSInitializationSettings();
//     var initSetttings = InitializationSettings(android: android, iOS: iOS);
//     flp.initialize(initSetttings);

//     var response =
//         await http.post('http://192.168.254.106/phpPractice/mobile/sample.php');
//     var convert = json.decode(response.body);
//     var convert2 = convert.where((i) => i['orgname'] == 'Alay lakad').toList();
//     print(convert2);
//     if (true) {
//       for (var i = 0; i <= convert2.length - 1; i++) {
//         showNotification(
//             i,
//             "Donation Status ${convert2[i]['statusDescription']}",
//             "Your donation from ${convert2[i]['orgName']}${convert2[i]['donation_boxID']}",
//             flp);
//       }
//     } else {
//       print("no message");
//     }

//     return Future.value(true);
//   });
// }

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
