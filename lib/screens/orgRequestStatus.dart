import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Request extends StatefulWidget {
  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  String orgname = "";
  Future getRequestData() async {
    var response = await http.post(
        "http://$myip/phpPractice/mobile/requestStatusApi.php",
        body: {'orgname': orgname});
    return json.decode(response.body);
  }

  Future getOrgname() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      orgname = preferences.getString('orgname');
    });
  }

  @override
  void initState() {
    super.initState();

    getOrgname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My request"),
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false,
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
                                // title: Text(
                                //     "Request ID : ${list[index]['requestID']}"),

                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // SizedBox(height: 20.0),
                                      // Text(
                                      //     "Request ID : ${list[index]['orgID']}"),
                                      // SizedBox(height: 10.0),
                                      Text("Name: ${list[index]['name']}"),
                                      SizedBox(height: 10.0),
                                      Text(
                                          "Quantity : ${list[index]['quantity']}"),
                                      SizedBox(height: 10.0),
                                      Text(
                                          "Description : ${list[index]['description']}"),
                                      SizedBox(height: 10.0),
                                      Text("Urgent : ${list[index]['Urgent']}"),
                                      SizedBox(height: 10.0),
                                      Text(
                                          "Request Date : ${list[index]['requestDate']}"),
                                      SizedBox(height: 10.0),
                                      Text(
                                          "Status: "
                                          "${list[index]['statusID'] == '1' ? 'Pending' : ''}"
                                          "${list[index]['statusID'] == '5' ? 'Approved' : ''}"
                                          "${list[index]['statusID'] == '6' ? 'Disapproved' : ''}",
                                          style:
                                              TextStyle(color: Colors.green)),
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
