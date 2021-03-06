import "package:flutter/material.dart";

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Account")),
        body: Container(
            child: Container(
          padding: EdgeInsets.all(24.0),
          child: Column(children: [
            TextFieldReusable(name: "Name", myValue: "Denzio"),
            TextFieldReusable(name: "Contact"),
            TextFieldReusable(name: "Password"),
            TextFieldReusable(name: "Confirm Password"),
            RaisedButton(
                color: Colors.red,
                onPressed: () {},
                child: Text("Update", style: TextStyle(color: Colors.white)))
          ]),
        )));
  }
}

class TextFieldReusable extends StatelessWidget {
  final String name;
  final String myValue;
  TextFieldReusable({this.name, this.myValue});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: myValue,
        decoration: InputDecoration(
          icon: Icon(Icons.person),
          labelText: name,
        ));
  }
}
