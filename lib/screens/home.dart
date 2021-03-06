import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Organization"),
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false),
      body: _buildListView(),
    );
  }
}

Widget _buildListView() {
  return ListView.builder(
      padding: EdgeInsets.all(20),
      itemCount: 10,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text("data"),
          subtitle: Text("Likes"),
        );
      });
}
