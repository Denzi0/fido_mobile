import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fido_project/screens/home.dart';
import 'package:fido_project/screens/match.dart';
import 'package:flutter/cupertino.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class DonationHome extends StatefulWidget {
  String requestID;
  String orgDescription;
  String orgName;
  DonationHome(
      {Key key,
      @required this.requestID,
      @required this.orgDescription,
      @required this.orgName})
      : super(key: key);
  @override
  _DonationHomeState createState() =>
      _DonationHomeState(this.requestID, this.orgDescription, this.orgName);
}

class _DonationHomeState extends State<DonationHome> {
  String requestID;
  String orgDescription;
  String orgName;
  _DonationHomeState(this.requestID, this.orgDescription, this.orgName);

  var _currencies = ["Food", "Item", "Clothes", "Both Food and Item", "Others"];
  String donorUsername = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController donationtitle = TextEditingController();

  TextEditingController donationname = TextEditingController();
  TextEditingController donationquantity = TextEditingController();
  TextEditingController description = TextEditingController();
  var _currentSelectedValue;

  void food() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    ///
    if (_formKey.currentState.validate()) {
      print('Hellowsdf df');
      var url = "http://$myip/phpPractice/mobile/donationHomeApi.php";
      var response = await http.post(url, body: {
        'orgID': requestID,
        'donorname': donorUsername,
        'donationname': donationname.text,
        'donationtype': (_currencies.indexOf(_currentSelectedValue)).toString(),
        'donationquantity': donationquantity.text,
        'description': description.text,
        'date': formattedDate,
      });
      var data = json.decode(response.body);
      if (data == "Success") {
        Fluttertoast.showToast(
            msg: "Donated to Org",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "Error DOnation",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Future getdonorFood() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      donorUsername = preferences.getString('username');
    });
  }

  @override
  void initState() {
    super.initState();
    getdonorFood();
    print(donorUsername);
    print(orgDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Donation"), backgroundColor: kprimaryColor),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Text(orgID),

                    Column(children: [
                      Text(orgName),
                      SizedBox(height: 10.0),
                      Text(orgDescription),
                      // SizedBox(height: 10.0),
                      // Text(requestID)
                    ]),
                    // _buildFoodDonFormField(
                    //     label: "Food Title", name: foodtitle),
                    _buildFoodDonFormField(
                      label: "Donation Name",
                      name: donationname,
                    ),
                    SizedBox(height: 20),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                          ),
                          isEmpty: _currentSelectedValue == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Donation Type"),
                              value: _currentSelectedValue,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _currentSelectedValue = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _currencies.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),

                    _buildFoodDonFormField(
                        label: "Donation Quanity",
                        keyType: TextInputType.number,
                        name: donationquantity),
                    SizedBox(
                      height: 20.0,
                    ),
                    _buildFoodDonFormField(
                        label: "Description", lines: 4, name: description),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonTheme(
                        height: 50.0,
                        child: RaisedButton(
                            onPressed: () {
                              print(donorUsername);

                              food();
                            },
                            color: Color(0xff00af91),
                            child: Text("Donate",
                                style: TextStyle(color: Colors.white))),
                      ),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}

Widget _buildFoodDonFormField(
    {String label,
    int lines,
    TextInputType keyType,
    @required TextEditingController name,
    String hintName}) {
  return TextFormField(
    controller: name,
    maxLines: lines,
    validator: (value) {
      if (value.isEmpty) {
        return "Please Input Food";
      } else {
        return null;
      }
    },
    keyboardType: keyType,
    decoration: InputDecoration(
        hintText: hintName,
        labelText: label,
        contentPadding: EdgeInsets.fromLTRB(0, 20, 0, 15)),
  );
}
