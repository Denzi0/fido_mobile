import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fido_project/constants/constantsVariable.dart';
import 'package:fido_project/screens/orgFeedback.dart';

class DonationBoxOrg extends StatefulWidget {
  @override
  _DonationBoxOrgState createState() => _DonationBoxOrgState();
}

class _DonationBoxOrgState extends State<DonationBoxOrg> {
  String orgUsername = "";
  String donorUsername = "";

  Future getOrgDonationBox() async {
    var url = "http://$myip/phpPractice/mobile/orgdonationBoxApi.php";
    var response = await http.post(url, body: {'orgUsername': orgUsername});
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
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false),
      body: FutureBuilder(
          future: getOrgDonationBox(),
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
                                          "Donation Box ID :${list[index]['donation_boxID']}"),
                                    ]),
                                subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      Text(
                                          "Donor Name : ${list[index]['donorName']}"),
                                      SizedBox(height: 10),
                                      Text(
                                          "My Request : ${list[index]['name']}"),
                                      SizedBox(height: 10),
                                      Text(
                                          "Donor Donation : ${list[index]['donationName']}"),
                                      SizedBox(height: 10),
                                      Text(
                                        "Donation Status : ${list[index]['statusDescription']}",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                    ]),
                                trailing: list[index]['statusDescription'] ==
                                        "Claimed by Organization"
                                    ? IconButton(
                                        icon: Icon(FontAwesomeIcons.commentAlt),
                                        tooltip: 'Delete donation',
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              CupertinoPageRoute(
                                                  builder: (context) =>
                                                      OrgFeedback(
                                                          donation_boxID: list[
                                                                  index][
                                                              'donation_boxID'])));
                                        },
                                      )
                                    : Text("")),
                          ),
                        ),
                      );
                    })
                : CircularProgressIndicator();
          }),
    );
  }
}
