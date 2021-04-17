import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DonationBox extends StatefulWidget {
  @override
  _DonationBoxState createState() => _DonationBoxState();
}

class _DonationBoxState extends State<DonationBox> {
  String orgUsername = "";
  String donorUsername = "";

  Future getDonationBox() async {
    var url = "http://$myip/phpPractice/mobile/donationBoxApi.php";
    var response = await http.post(url, body: {'donorUsername': donorUsername});
    return json.decode(response.body);
  }

  Future getUsername() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      orgUsername = preferences.getString('orgname');
    });
    setState(() {
      donorUsername = preferences.getString('username');
    });
  }

  @override
  void initState() {
    super.initState();
    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Donation Box"),
          automaticallyImplyLeading: false,
          backgroundColor: kprimaryColor,
        ),
        body: FutureBuilder(
            future: getDonationBox(),
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
                                title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Donation ID :${list[index]['donationID']}"),
                                      SizedBox(height: 10),
                                      Text(
                                          "Donation Box ID : ${list[index]['donation_boxID']}"),
                                    ]),

                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                          "Organization Name : ${list[index]['orgName']}"),
                                      SizedBox(height: 10),
                                      Text(
                                        "Donation Request Name : ${list[index]['name']}",
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "My donation : ${list[index]['donationName']}",
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Feedback : ${list[index]['orgFeedback']}",
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Donation Status : ${list[index]['statusDescription']}",
                                        style: TextStyle(color: Colors.green),
                                      ),
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
