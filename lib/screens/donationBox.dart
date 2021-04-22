import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fido_project/alertDialog.dart';

class DonationBox extends StatefulWidget {
  @override
  _DonationBoxState createState() => _DonationBoxState();
}

class _DonationBoxState extends State<DonationBox> {
  String orgUsername = "";
  String donorUsername = "";
  List orgList;
  List orgdetailsList;
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
  }

  void organizationDetails(orgName) async {
    print(orgName);
    var url = "http://$myip/phpPractice/mobile/trackingOrgDetailsApi.php";
    var response = await http.post(url, body: {'orgusername': orgName});
    var data = json.decode(response.body);

    setState(() {
      orgdetailsList = data;
    });
    print(orgdetailsList);
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
    // print(orgdetailsList);
    // organizationDetails();

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
                                        "Feedback : ${list[index]['orgFeedback']}",
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        "Donation Status : ${list[index]['statusDescription']}",
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      SizedBox(height: 10),
                                      Wrap(children: [
                                        ButtonTheme(
                                          height: 40.0,
                                          child: list[index]
                                                      ['statusDescription'] ==
                                                  'Pending'
                                              ? RaisedButton(
                                                  onPressed: () {
                                                    deliverDonation(
                                                        list[index]
                                                            ['donation_boxID'],
                                                        2);
                                                  },
                                                  color: kprimaryColor,
                                                  child: Text("Donation Ready",
                                                      style: TextStyle(
                                                          color: Colors.white)))
                                              : list[index]['statusDescription'] ==
                                                      'Donation Ready to Deliver'
                                                  ? RaisedButton(
                                                      onPressed: () {
                                                        deliverDonation(
                                                            list[index][
                                                                'donation_boxID'],
                                                            3);
                                                      },
                                                      color: kprimaryColor,
                                                      child: Text(
                                                          "Deliver Donation",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white)))
                                                  : list[index]['statusDescription'] ==
                                                          'Donation-In-transit'
                                                      ? RaisedButton(
                                                          onPressed: () {
                                                            deliverDonation(
                                                                list[index][
                                                                    'donation_boxID'],
                                                                4);
                                                          },
                                                          color: kprimaryColor,
                                                          child: Text("Drop-off",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white)))
                                                      : Container(),
                                        ),
                                        // ButtonTheme(
                                        //   height: 40.0,
                                        //   child: RaisedButton(
                                        //       onPressed: () {
                                        //         print(
                                        //             "For pick up by organization");
                                        //       },
                                        //       color: kprimaryColor,
                                        //       child: Text("For pick-up by org",
                                        //           style: TextStyle(
                                        //               color: Colors.white))),
                                        // )
                                      ])
                                    ]),
                                trailing: IconButton(
                                  icon: Icon(FontAwesomeIcons.infoCircle),
                                  tooltip: 'Organization details',
                                  onPressed: () {
                                    organizationDetails(list[index]['orgName']);
                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Container(
                                          height: 200,
                                          color: Colors.amber,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
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
                                                            (context, index) {
                                                          orgList =
                                                              orgdetailsList;
                                                          return ListTile(
                                                            title: Text(orgList[
                                                                    index]
                                                                ['orgName']),
                                                          );
                                                        }),
                                                  ),
                                                ),
                                                const Text('Modal BottomSheet'),
                                                ElevatedButton(
                                                  child: const Text(
                                                      'Close BottomSheet'),
                                                  onPressed: () =>
                                                      Navigator.pop(context),
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
            }));
  }
}
// ListView.builder(
//                                                     itemCount:
//                                                         orgdetailsList.length,
//                                                     itemBuilder:
//                                                         (context, index) {
//                                                       orgList = orgdetailsList;
//                                                       return ListTile(
//                                                         title: Text(
//                                                             orgList[index]
//                                                                 ['orgName']),
//                                                       );
//                                                     }),
