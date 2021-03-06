import 'package:fido_project/alertDialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fido_project/screens/donorLogin.dart';
import 'package:fido_project/screens/donorAccount.dart';
import 'package:flutter/cupertino.dart';

class DonorProfile extends StatefulWidget {
  @override
  _DonorProfileState createState() => _DonorProfileState();
}

class _DonorProfileState extends State<DonorProfile> {
  // final _formKey = GlobalKey<FormState>();

  // SharedPreferences logout and keep login in
  String username = "";
  Future getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
  }

  Future logout(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove('username');
    Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  ////// up to here
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Card(
            child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                    child: username == ''
                        ? Text('')
                        : Text("Hello $username",
                            style: TextStyle(fontSize: 20)))),
          ),
          Card(
              child: ListTile(
            leading: Icon(FontAwesomeIcons.userCircle),
            title: Text('Account'),
            subtitle: Text('Edit Account details'),
            onTap: () {
              Navigator.push(
                  context, CupertinoPageRoute(builder: (context) => Account()));
            },
          )),
          // Card(
          //     child: ListTile(
          //   leading: Icon(FontAwesomeIcons.commentDots),
          //   title: Text('App feedback'),
          //   subtitle: Text('Write anything about us'),
          //   onTap: () {
          //     print("app feedback");
          //   },
          // )),
          Card(
              child: ListTile(
            leading: Icon(FontAwesomeIcons.questionCircle),
            title: Text('About-us'),
            subtitle: Text('Our mission and Vision'),
            onTap: () {
              print("about us");
            },
          )),
          Card(
              child: ListTile(
            leading: Icon(FontAwesomeIcons.signOutAlt),
            title: Text('Logout'),
            subtitle: Text('Temporarily Log-out to account'),
            onTap: () async {
              final action = await AlertDialogs.yesAbortDialog(
                  context, "Are you sure", "Do you want to log-out ?");
              if (action == DialogAction.yes) {
                logout(context);
              }
              // logout(context);
            },
          )),
        ],
      ),
      // SharedPreferences logout and keep login in
    );
  }
}

// class InputDonorProfile extends StatelessWidget {
//   const InputDonorProfile({this.username, this.textlabel});

//   final String username;
//   final String textlabel;
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       decoration: InputDecoration(hintText: username),
//     );
//   }
// }
