import 'package:fido_project/screens/donorLogin.dart';
import 'package:fido_project/screens/donorProfile.dart';
import 'package:fido_project/screens/menu.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  //Flutter sessions
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var username = preferences.getString('username');

  // the Shared preferences
  runApp(MaterialApp(home: username == null ? Login() : Welcome()));
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
