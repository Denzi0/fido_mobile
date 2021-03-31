import 'package:fido_project/screens/donorProfile.dart';
import 'package:fido_project/screens/orgRequests.dart';
import 'package:fido_project/screens/orgRequestStatus.dart';
import 'package:fido_project/screens/orgDonationBox.dart';
import 'package:fido_project/screens/orgProfile.dart';

import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class WelcomeOrg extends StatefulWidget {
  @override
  _WelcomeOrgState createState() => _WelcomeOrgState();
}

class _WelcomeOrgState extends State<WelcomeOrg> {
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
