import 'package:fido_project/screens/orgRequests.dart';
import 'package:fido_project/screens/orgRequestStatus.dart';
import 'package:fido_project/screens/orgDonationBox.dart';
import 'package:fido_project/screens/orgProfile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;

import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';
import 'package:workmanager/workmanager.dart';

const orgNoti = "orgNoti";
var orgUname = '';
void showNotification(id, v, y, flp) async {
  var android = AndroidNotificationDetails(
      'ChannelID', 'channel NAME', 'CHANNEL DESCRIPTION',
      priority: Priority.high, importance: Importance.max);
  var iOS = IOSNotificationDetails();
  var platform = NotificationDetails(android: android, iOS: iOS);
  await flp.show(id, '$y', '$v', platform, payload: 'VIS \n $v');
}

void globalVariable(orgUsername) {
  orgUname = orgUsername;
  return;
}

void start() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Workmanager.initialize(callbackDispatcher, isInDebugMode: true);
  await Workmanager.registerPeriodicTask("5", orgNoti,
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
    var org = json.decode(response.body);
    var orgconvert = org.where((i) => i['orgName'] == 'House of Hope').toList();
    print("Array $orgconvert");
    if (true) {
      for (var i = 0; i <= orgconvert.length - 1; i++) {
        showNotification(
            i,
            "Donation Status ${orgconvert[i]['statusDescription']}\nDonation Box ID${orgconvert[i]['donation_boxID']}",
            "Your donation from ${orgconvert[i]['donorName']}\n${orgconvert[i]['date_given']}",
            flp);
      }
    }

    return Future.value(true);
  });
}

// ignore: must_be_immutable
class WelcomeOrg extends StatefulWidget {
  String orgUsername;
  WelcomeOrg({Key key, @required this.orgUsername}) : super(key: key);
  @override
  _WelcomeOrgState createState() => _WelcomeOrgState(this.orgUsername);
}

class _WelcomeOrgState extends State<WelcomeOrg> {
  String orgUsername;
  _WelcomeOrgState(this.orgUsername);
  @override
  void initState() {
    super.initState();

    print(orgNoti);
    // globalVariable(orgUsername);
    start();
  }
  //data from orglogin

  // data from orglogin
  int _selectedIndex = 0;
  final tabs = [
    OrgRequests(),
    Request(),
    DonationBoxOrg(),
    OrgProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[_selectedIndex],
        bottomNavigationBar: FFNavigationBar(
          theme: FFNavigationBarTheme(
            barBackgroundColor: Colors.white,
            selectedItemBorderColor: Color(0xff00af91),
            selectedItemBackgroundColor: kprimaryColor,
            selectedItemIconColor: Colors.white,
            selectedItemLabelColor: Colors.black,
            // barHeight: 70,
          ),
          selectedIndex: _selectedIndex,
          onSelectTab: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          items: [
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.handHoldingHeart,
              label: 'Request',
              itemWidth: 2,
            ),
            FFNavigationBarItem(
              iconData: Icons.note,
              label: 'My request',
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.archive,
              label: 'Donation Box',
            ),
            FFNavigationBarItem(
              iconData: FontAwesomeIcons.solidUserCircle,
              label: 'Profile',
            ),
          ],
        ));
  }
}

//   currentIndex: _selectedIndex,
//   fixedColor: Color(0xff11cf81),
//   type: BottomNavigationBarType.fixed,
//   items: [
//     BottomNavigationBarItem(
//       icon: Icon(FontAwesomeIcons.handHoldingHeart),
//       title: Text("Requests"),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(FontAwesomeIcons.scroll),
//       title: Text("My Request"),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(FontAwesomeIcons.solidUserCircle),
//       title: Text("Donations"),
//     ),
//     BottomNavigationBarItem(
//       icon: Icon(FontAwesomeIcons.solidUserCircle),
//       title: Text("Profile"),
//     ),
//   ],
//   onTap: (index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   },
// ),
