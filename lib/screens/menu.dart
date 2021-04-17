import 'dart:convert';
import 'package:fido_project/constants/constantsVariable.dart';
import 'package:fido_project/screens/foodanditemDonation.dart';
import 'package:fido_project/screens/donorProfile.dart';
import 'package:fido_project/screens/donationStatus.dart';
import 'package:fido_project/screens/donationBox.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fido_project/screens/home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:workmanager/workmanager.dart';

const donorNoti = "donorNoti";

void showNotification(id, v, y, flp) async {
  var android = AndroidNotificationDetails(
      'ChannelID', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(
    id,
    '$y',
    '$v',
    platform,
    payload: 'VIS \n $v',
  );
}

void start() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager.registerPeriodicTask("5", donorNoti,
      existingWorkPolicy: ExistingWorkPolicy.replace,
      frequency: Duration(minutes: 15), //when should it check the link
      initialDelay:
          Duration(seconds: 5), //duration before showing the notification
      constraints: Constraints(
        networkType: NetworkType.connected,
      ));
}

void callbackDispatcher() {
  Workmanager.executeTask((task, inputData) async {
    FlutterLocalNotificationsPlugin flp = FlutterLocalNotificationsPlugin();
    var android = AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = IOSInitializationSettings();
    var initSetttings = InitializationSettings(android: android, iOS: iOS);
    flp.initialize(initSetttings);

    var response =
        await http.post('http://$myip/phpPractice/mobile/sample.php');
    var convert = json.decode(response.body);
    var convert2 = convert.where((i) => i['donorName'] == 'John Doe').toList();
    print("Array $convert2");
    if (true) {
      // showNotification(0, "Donation Status", "Your donation from", flp);
      //
      for (var i = 0; i <= convert2.length - 1; i++) {
        showNotification(
            i,
            "Donation Status ${convert2[i]['statusDescription']}",
            "Your donation to ${convert2[i]['orgName']} ${convert2[i]['date_given']}",
            flp);
      }
    }

    return Future.value(true);
  });
}

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    start();
  }

  int selectedIndex = 0;
  PageController _pageController;

  final tabs = [
    Home(),
    DonationBox(),
    // DonationCategory(),
    FoodandItem(),
    Donations(),
    DonorProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[selectedIndex],
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            selectedItemBorderColor: ksecondaryColor,
            selectedItemBackgroundColor: kprimaryColor,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.black,
            // barHeight: 70,
          ),
          selectedIndex: selectedIndex,
          onSelectTab: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
          items: [
            FFNavigationBarItem(
              iconData: Icons.home,
              label: 'Home',
              itemWidth: 2,
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.archive,
              label: 'Donation Box',
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.hands,
              label: 'Donation',
            ),
            FFNavigationBarItem(
              iconData: Icons.text_snippet,
              label: 'My Donation',
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.solidUserCircle,
              label: 'Profile',
            ),
          ],
        ));
  }
}
//  Scaffold(
//       body: tabs[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _currentIndex,
//         fixedColor: Color(0xff11cf81),
//         type: BottomNavigationBarType.fixed,
//         items: [
//           BottomNavigationBarItem(
//             icon: Icon(FontAwesomeIcons.home),
//             title: Text("Home"),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(FontAwesomeIcons.archive),
//             title: Text("Donations"),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(FontAwesomeIcons.boxOpen),
//             title: Text("Donate"),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(FontAwesomeIcons.scroll),
//             title: Text(""),
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(FontAwesomeIcons.solidUserCircle),
//             title: Text("Profile"),
//           ),
//         ],
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//       ),
//     );
