import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:fido_project/alertDialog.dart';

// ignore: must_be_immutable
class DonationBox extends StatefulWidget {
  String buttonName;
  @override
  _DonationBoxState createState() => _DonationBoxState();
}

class _DonationBoxState extends State<DonationBox> {
  String orgUsername = "";
  String donorUsername = "";
  List orgList = [];
  List orgdetailsList = [];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  Future getDonationBox() async {
    var url = "http://$myip/phpPractice/mobile/donationBoxApi.php";
    var response = await http.post(url, body: {'donorUsername': donorUsername});
    return json.decode(response.body);
  }

  void deliverDonation(donationBoxID, trackingNumber) async {
    var url = "http://$myip/phpPractice/mobile/trackingDeliverDonationApi.php";
    var response = await http.post(url, body: {
      'donation_boxID': donationBoxID,
      'trackingNumber': trackingNumber.toString()
    });

    var data = json.decode(response.body);
    if (data == "Success") {
      print("Success");
    }
    setState(() {});
  }

  void organizationDetails(orgName) async {
    var url = "http://$myip/phpPractice/mobile/trackingOrgDetailsApi.php";
    var response = await http.post(url, body: {'orgusername': orgName});
    var data = json.decode(response.body);
    setState(() {
      orgdetailsList = data;
    });
    return;
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
    getDonationBox();

    getUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Donor Donation Box"),
          automaticallyImplyLeading: false,
          backgroundColor: kprimaryColor,
        ),
        body: FutureBuilder(
            future: getDonationBox(),
            builder: (context, snapshot) {
              if (snapshot.hasError) print(snapshot.error);
              return snapshot.hasData
                  ? RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: getRefresh,
                      child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            List list = snapshot.data;
                            organizationDetails(list[index]['orgName']);
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
                                          // Text(
                                          //     "Donation ID :${list[index]['donationID']}"),
                                          // SizedBox(height: 10),
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
                                              "Donation Quantity : ${list[index]['donation_quantity']}"),
                                          // SizedBox(height: 10),
                                          // Text(
                                          //   "Donor : ${list[index]['donationStatus']}",
                                          // ),
                                          SizedBox(height: 10),

                                          Text(
                                            "Date : ${list[index]['date_given']}",
                                          ),
                                          SizedBox(height: 10),

                                          Text(
                                            "Feedback : ${list[index]['orgFeedback']}",
                                          ),
                                          SizedBox(height: 10),

                                          Text(
                                            "Donation Status : ${list[index]['statusDescription']}",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),

                                          // SizedBox(height: 10),

///////////////
                                          ///
                                          // list[index]['donationStatus'] == '5'
                                          ///
                                          list[index]['quantity'] == '0'
                                              ? Wrap(children: [
                                                  ButtonTheme(
                                                    height: 40.0,
                                                    child: list[index]['statusDescription'] ==
                                                            'Pending'
                                                        ? RaisedButton(
                                                            onPressed: () {
                                                              deliverDonation(
                                                                  list[index][
                                                                      'donation_boxID'],
                                                                  2);
                                                            },
                                                            color:
                                                                kprimaryColor,
                                                            child: Text(
                                                                "Donation Ready",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white)))
                                                        : list[index]['statusDescription'] ==
                                                                'Donation Ready to Deliver'
                                                            ? RaisedButton(
                                                                onPressed: () {
                                                                  deliverDonation(
                                                                      list[index]
                                                                          [
                                                                          'donation_boxID'],
                                                                      3);
                                                                },
                                                                color:
                                                                    kprimaryColor,
                                                                child: Text(
                                                                    "Deliver Donation",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .white)))
                                                            : list[index]
                                                                        ['statusDescription'] ==
                                                                    'Donation-In-transit'
                                                                ? RaisedButton(
                                                                    onPressed: () {
                                                                      deliverDonation(
                                                                          list[index]
                                                                              [
                                                                              'donation_boxID'],
                                                                          4);
                                                                    },
                                                                    color: kprimaryColor,
                                                                    child: Text("Dropped-off", style: TextStyle(color: Colors.white)))
                                                                : Container(),
                                                  ),
                                                ])
                                              : Text('')
                                        ]),
                                    trailing: IconButton(
                                      icon: Icon(FontAwesomeIcons.mapMarkerAlt),
                                      tooltip: 'Organization details',
                                      onPressed: () {
                                        showModalBottomSheet<void>(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Container(
                                              height: 200,
                                              color: Colors.white,
                                              child: Center(
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: SizedBox(
                                                        child: ListView.builder(
                                                            shrinkWrap:
                                                                true, // use it
                                                            itemCount:
                                                                orgdetailsList
                                                                    .length,
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              orgList =
                                                                  orgdetailsList;
                                                              return ListTile(
                                                                title: Column(
                                                                    children: [
                                                                      SizedBox(
                                                                          height:
                                                                              10.0),
                                                                      Text(orgList[
                                                                              index]
                                                                          [
                                                                          'orgName']),
                                                                    ]),
                                                                subtitle:
                                                                    Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                        'Person-in-charge : ${orgList[index]['orgPersonInCharge']}'),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                        'Address : ${orgList[index]['orgAddress']}'),
                                                                    SizedBox(
                                                                        height:
                                                                            10),
                                                                    Text(
                                                                        'Contact : ${orgList[index]['orgContact']}')
                                                                  ],
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                    ElevatedButton(
                                                      child:
                                                          const Text('Close'),
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
                          }),
                    )
                  : CircularProgressIndicator();
            }));
  }
}

Future<Null> getRefresh() async {
  await Future.delayed(Duration(seconds: 1));
}
