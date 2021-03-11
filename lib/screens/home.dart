import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fido_project/screens/donationHome.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future getRequestData() async {
    // var url = 'http://';
    var response = await http
        .post("http://192.168.254.106/phpPractice/mobile/requestApi.php");
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Organization"),
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false,
          // actions: <Widget>[
          //   IconButton(icon: Icon(Icons.search), onPressed: () {})
          // ],
        ),
        body: FutureBuilder(
            future: getRequestData(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        List list = snapshot.data;
                        return Container(
                          margin: EdgeInsets.all(5.0),
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: ListTile(
                                // isThreeLine: true,
                                title: Text(list[index]["orgID"] ?? "Admin"),

                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20.0),
                                      Text("Name : ${list[index]['name']}"),
                                      SizedBox(height: 20.0),
                                      Text(
                                          "Quantity : ${list[index]['quantity']}"),
                                      SizedBox(height: 20.0),
                                      Text(
                                          "Description: ${list[index]['description']}"),
                                      SizedBox(height: 25.0),
                                      Row(
                                        children: [
                                          RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            DonationHome()));
                                                print(
                                                    list[index]['description']);
                                              },
                                              color: Colors.blue,
                                              child: Text("Donate",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                          SizedBox(width: 20.0),
                                          RaisedButton(
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                        builder: (context) =>
                                                            DonationHome()));
                                                print(
                                                    list[index]['description']);
                                              },
                                              color: Colors.red,
                                              child: Text("Save",
                                                  style: TextStyle(
                                                      color: Colors.white))),
                                        ],
                                      )
                                    ]),
                              ),
                            ),
                          ),
                        );
                      })
                  : CircularProgressIndicator();
            }));
  }
}

// class DataSearch extends SearchDelegate<String> {
//   final recent = ["hellow", "ahie"];
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [IconButton(icon: Icon(Icons.clear), onPressed: () {})];
//   }

//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//         icon: AnimatedIcon(
//             icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
//         onPressed: () {});
//   }

//   @override
//   Widget buildResults(BuildContext context) {
//     // TODO: implement buildResults
//     throw UnimplementedError();
//   }

//   @override
//   Widget buildSuggestions(BuildContext context) {
//     final suggetionList = query.isEmpty ? recent : "";
//   }
// }
