import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  List donordetailsList;
  List donorList = [];
  Future getOrgDonationBox() async {
    var url = "http://$myip/phpPractice/mobile/orgdonationBoxApi.php";
    var response = await http.post(url, body: {'orgUsername': orgUsername});
    return json.decode(response.body);
  }

  void donorDetails(donorName) async {
    var url = "http://$myip/phpPractice/mobile/trackingDonorDetailsApi.php";
    var response = await http.post(url, body: {'donorName': donorName});
    var data = json.decode(response.body);
    setState(() {
      donordetailsList = data;
    });
    print(donordetailsList);
    setState(() {});
  }

  void donationRecieved(donationID, donationBoxID, trackingNumber, requestID,
      donationQuantity) async {
    var url =
        'http://$myip/phpPractice/mobile/trackingOrgDeliverDonationApi.php';
    var response = await http.post(url, body: {
      'donation_boxID': donationBoxID,
      'trackingNumber': trackingNumber.toString(),
      'donationID': donationID,
      'requestID': requestID,
      'donationQuantity': donationQuantity
    });
    if (response.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Donation Recieved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: kprimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
    }
    setState(() {});
  }

  void approvedDonation(donationBoxID) async {
    print(donationBoxID);
    var url = 'http://$myip/phpPractice/mobile/trackingApprovedApi.php';
    var response =
        await http.post(url, body: {'donation_boxID': donationBoxID});
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
          title: Text("Organization Donation Box"),
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Donation Box ID :${list[index]['donation_boxID']}"),
                                  ]),
                              subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),
                                    Text(
                                        "Donor Name : ${list[index]['donorName']}"),
                                    SizedBox(height: 10),
                                    Text("My Request : ${list[index]['name']}"),
                                    SizedBox(height: 10),
                                    Text(
                                        "Donor Donation : ${list[index]['donationName']}"),
                                    SizedBox(height: 10),
                                    Text(
                                      "Donor Status : ${list[index]['donationStatus']}",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    Text(
                                      "Donation Status : ${list[index]['statusDescription']}",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    SizedBox(height: 10),
                                    Row(children: [
                                      list[index]['donationStatus'] == "5"
                                          ? ButtonTheme(
                                              height: 40.0,
                                              child: RaisedButton(
                                                  onPressed: () {
                                                    donationRecieved(
                                                        list[index]
                                                            ['donationID'],
                                                        list[index]
                                                            ['donation_boxID'],
                                                        7,
                                                        list[index]
                                                            ['requestID'],
                                                        list[index][
                                                            'donation_quantity']);
                                                  },
                                                  color: kprimaryColor,
                                                  child: Text(
                                                      "Donation Recieved",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                            )
                                          : ButtonTheme(
                                              height: 40.0,
                                              child: RaisedButton(
                                                  onPressed: () {
                                                    approvedDonation(list[index]
                                                        ['donation_boxID']);
                                                  },
                                                  color: kprimaryColor,
                                                  child: Text("Approved",
                                                      style: TextStyle(
                                                          color:
                                                              Colors.white))),
                                            ),
                                      SizedBox(width: 10.0),
                                    ])
                                  ]),
                              trailing:
                                  list[index]['statusDescription'] ==
                                          "Claimed By Organization"
                                      ? IconButton(
                                          icon:
                                              Icon(FontAwesomeIcons.commentAlt),
                                          tooltip: 'feedback donation',
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        OrgFeedback(
                                                          donationboxID: list[
                                                                  index][
                                                              'donation_boxID'],
                                                        )));
                                          },
                                        )
                                      : IconButton(
                                          icon: Icon(
                                              FontAwesomeIcons.mapMarkerAlt),
                                          tooltip: 'Organization details',
                                          onPressed: () {
                                            donorDetails(
                                                list[index]['donorName']);

                                            showModalBottomSheet<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return Container(
                                                  height: 200,
                                                  color: Colors.white,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Expanded(
                                                          child: SizedBox(
                                                            child: ListView
                                                                .builder(
                                                                    shrinkWrap:
                                                                        true, // use it
                                                                    itemCount:
                                                                        donordetailsList
                                                                            .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      donorList =
                                                                          donordetailsList;
                                                                      return ListTile(
                                                                        title: Column(
                                                                            children: [
                                                                              SizedBox(height: 10.0),
                                                                              Text(donorList[index]['donorName']),
                                                                            ]),
                                                                        subtitle:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          children: [
                                                                            SizedBox(height: 10),
                                                                            Text('Donor Name : ${donorList[index]['donorName']}'),
                                                                            SizedBox(height: 10),
                                                                            Text('Address : ${donorList[index]['donorAddress']}'),
                                                                            SizedBox(height: 10),
                                                                            Text('Contact : ${donorList[index]['donorContact']}')
                                                                          ],
                                                                        ),
                                                                      );
                                                                    }),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          child: const Text(
                                                              'Close'),
                                                          onPressed: () =>
                                                              Navigator.pop(
                                                                  context),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                            // Navigator.push()
                                          },
                                        ),
                            ),
                          ),
                        ),
                      );
                    })
                : CircularProgressIndicator();
          }),
    );
  }
}
