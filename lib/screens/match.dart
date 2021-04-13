import 'dart:convert';
import 'dart:typed_data';

import 'package:fido_project/constants/constantsVariable.dart';
import 'package:fido_project/screens/donationHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fido_project/screens/menu.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class Match extends StatefulWidget {
  String donationNameMatch;
  String donationTypeMatch;
  String donationQuantityMatch;
  String donationDescription;
  Match(
      {Key key,
      @required this.donationNameMatch,
      @required this.donationTypeMatch,
      @required this.donationQuantityMatch,
      @required this.donationDescription})
      : super(key: key);
  @override
  _MatchState createState() => _MatchState(
      this.donationNameMatch,
      this.donationTypeMatch,
      this.donationQuantityMatch,
      this.donationDescription);
}

class _MatchState extends State<Match> {
  List requestList = [];
  List list = [];

  String donationNameMatch;
  String donationTypeMatch;
  String donationQuantityMatch;
  String donationDescription;
  String _donorUsername;

  _MatchState(this.donationNameMatch, this.donationTypeMatch,
      this.donationQuantityMatch, this.donationDescription);

  Future donateMatch() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);
    print(_donorUsername);
    print(donationNameMatch);

    print(donationQuantityMatch);
    print(donationDescription);
    print(formattedDate);
    var url = 'http://$myip/phpPractice/mobile/donationMatch.php';
    var response = await http.post(url, body: {
      // this is static cuzz
      // 'orgID': reqID.toString(),
      'donorname': _donorUsername,
      'donationname': donationNameMatch,
      'donationtype': donationTypeMatch,
      'donationquantity': donationQuantityMatch,
      'description': donationTypeMatch,
      'date': formattedDate,
    });

    var data = json.decode(response.body);
    if (data == "Success") {
      Fluttertoast.showToast(
          msg: "Donated to Match Organization",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0);
      print("succ");
    }
  }

  Future getdonorFood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      _donorUsername = preferences.getString('username');
    });
  }

  Future _donationRequest() async {
    var url = "http://$myip/phpPractice/mobile/donationMatchApi.php";
    var response =
        await http.post(url, body: {"donationMatch": donationNameMatch});

    setState(() {
      requestList = json.decode(response.body);
    });
  }

  void initState() {
    super.initState();
    getdonorFood();
    _donationRequest();
  }

  Widget showImageMatch(String image) {
    // final UriData data = Uri.parse(image).data;
    // print(data.isBase64); // Should print true
    // print(data.contentAsBytes());
    String placeholder =
        "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
    if (image?.isEmpty ?? true)
      return Container();
    else {
      switch (image.length % 4) {
        case 1:
          break; // this case can't be handled well, because 3 padding chars is illeagal.
        case 2:
          image = image + "==";
          break;
        case 3:
          image = image + "=";
          break;
      }
    }
    Uint8List _bytesImage;
    String _imgString = image;
    _bytesImage = Base64Decoder().convert(_imgString);
    return Image.memory(_bytesImage,
        width: double.infinity,
        height: 200,
        gaplessPlayback: true,
        fit: BoxFit.fill);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Match"),
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false),
      body: ListView.builder(
          padding: EdgeInsets.all(20),
          itemCount: requestList.length,
          itemBuilder: (context, index) {
            list = requestList;
            return requestList == null
                ? Center(child: Text("Loading..."))
                : Card(
                    child: Column(
                      children: [
                        showImageMatch(list[index]['images']),
                        ListTile(
                            subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10.0),
                            Text(
                                "Organization Name : ${list[index]['orgName']}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            SizedBox(height: 10.0),
                            Text("Request name :${list[index]['name']}"),
                            SizedBox(height: 10.0),
                            Text("Quantity : ${list[index]['quantity']}"),
                            SizedBox(height: 10.0),
                            Text("Description: ${list[index]['description']}"),
                            SizedBox(height: 10.0),
                            Text("Date: ${list[index]['requestDate']}"),
                            SizedBox(height: 10.0),
                            Row(
                              children: [
                                RaisedButton(
                                    color: ksecondaryColor,
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  DonationHome(
                                                      orgName: list[index]
                                                          ['orgName'],
                                                      orgDescription:
                                                          list[index]
                                                              ['description'],
                                                      requestID: list[index]
                                                          ['requestID'])));
                                    },
                                    child: Text("Donate Here",
                                        style: TextStyle(color: Colors.white))),
                              ],
                            )
                          ],
                        ))
                      ],
                    ),
                  );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Welcome()));
        },
        child: Icon(Icons.home),
        backgroundColor: ksecondaryColor,
      ),
    );
  }
}
