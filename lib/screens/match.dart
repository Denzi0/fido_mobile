import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:fido_project/screens/menu.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Match extends StatefulWidget {
  @override
  _MatchState createState() => _MatchState();
}

class _MatchState extends State<Match> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Match"),
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false),
      body: _buildListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Welcome()));
        },
        child: Icon(Icons.keyboard_arrow_left),
        backgroundColor: Colors.blue,
      ),
    );
  }
}

Widget _buildListView() {
  return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("Match"),
          subtitle: Text("Organization Name"),
        );
      });
}
