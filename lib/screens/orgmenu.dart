import 'package:fido_project/screens/donorProfile.dart';
import 'package:fido_project/screens/orgRequests.dart';
import 'package:fido_project/screens/orgRequestStatus.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeOrg extends StatefulWidget {
  @override
  _WelcomeOrgState createState() => _WelcomeOrgState();
}

class _WelcomeOrgState extends State<WelcomeOrg> {
  //data from orglogin

  // data from orglogin
  int _currentIndex = 0;
  final tabs = [
    OrgRequests(),
    Request(),
    Center(child: Text("Profile")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Color(0xff11cf81),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.handHoldingHeart),
            title: Text("Requests"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.scroll),
            title: Text("Notifications"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.solidUserCircle),
            title: Text("Profile"),
          ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
