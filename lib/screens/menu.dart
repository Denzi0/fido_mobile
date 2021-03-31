import 'package:fido_project/constants/constantsVariable.dart';
import 'package:fido_project/screens/foodanditemDonation.dart';
import 'package:fido_project/screens/donorProfile.dart';
import 'package:fido_project/screens/donationStatus.dart';
import 'package:fido_project/screens/donationBox.dart';

import 'package:flutter/material.dart';
import 'package:fido_project/screens/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:ff_navigation_bar/ff_navigation_bar.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
