import 'package:fido_project/screens/foodanditemDonation.dart';
import 'package:fido_project/screens/donorProfile.dart';
import 'package:fido_project/screens/donationStatus.dart';

import 'package:flutter/material.dart';
import 'package:fido_project/screens/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fido_project/constants/constantsVariable.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _currentIndex = 0;

  final tabs = [
    Home(),
    Center(child: Text("Drop-off")),
    // DonationCategory(),
    FoodandItem(),
    Donations(),
    DonorProfile(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(backgroundColor: kprimaryColor),
      // drawer: Drawer(
      //   child: ListView(children: [
      //     DrawerHeader(
      //       child: Text("Drawer Header"),
      //     ),
      //     ListTile(
      //         title: Text("Item 1"),
      //         onTap: () {
      //           print("item 1");
      //         }),
      //     ListTile(
      //         title: Text("Item 2"),
      //         onTap: () {
      //           print("item 2");
      //         })
      //   ]),
      // ),
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        fixedColor: Color(0xff11cf81),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.home),
            title: Text("Home"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.mapMarkedAlt),
            title: Text("Drop-Off"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.boxOpen),
            title: Text("Donate"),
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.scroll),
            title: Text("Donations"),
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
