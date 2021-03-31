import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Donations extends StatefulWidget {
  @override
  _DonationsState createState() => _DonationsState();
}

class _DonationsState extends State<Donations> {
  String username = "";
  Future getDonationData() async {
    var response = await http.post(
        "http://192.168.254.106/phpPractice/mobile/donationStatusApi.php",
        body: {'username': username});
    return json.decode(response.body);
  }

  Future getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString('username');
    });
  }

  Future deleteDonation() async {}
  @override
  void initState() {
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Donation Status"),
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
            future: getDonationData(),
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
                                // title: Text(list[index]["donorID"]),

                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Donation ID : ${list[index]['donationID']}"),
                                      SizedBox(height: 20.0),
                                      Text(
                                          "Donation name : ${list[index]['donationName']}"),
                                      SizedBox(height: 20.0),
                                      Text(
                                          "Quantity : ${list[index]['donation_quantity']}"),
                                      SizedBox(height: 20.0),
                                      Text(
                                          "Description : ${list[index]['donation_description']}"),
                                      SizedBox(height: 20.0),
                                      Text("Date: ${list[index]['date']}"),
                                      SizedBox(height: 20.0),
                                      Text(
                                          "Date Received : ${list[index]['date_received'] != null ? list[index]['date_received'] : 'Not recieve Yet'}"),
                                      SizedBox(height: 20.0),
                                      Text(
                                          "Donation Status : "
                                          "${list[index]['statusID'] == '1' ? 'Pending' : ''}"
                                          "${list[index]['statusID'] == '5' ? 'Approved' : ''}"
                                          "${list[index]['statusID'] == '6' ? 'Disapproved' : ''}",
                                          style: TextStyle(
                                            color: ksecondaryColor,
                                          )),
                                    ]),
                                trailing: IconButton(
                                  icon: Icon(FontAwesomeIcons.timesCircle),
                                  tooltip: 'Delete donation',
                                  onPressed: () {
                                    print("pressdelete");
                                  },
                                ),
                              ),
                            ),
                          ),
                        );
                      })
                  : CircularProgressIndicator();
            }));
  }
}
