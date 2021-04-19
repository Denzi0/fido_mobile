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

class FoodandItem extends StatefulWidget {
  @override
  _FoodandItemState createState() => _FoodandItemState();
}

class _FoodandItemState extends State<FoodandItem> {
  var _currentSelectedValue;
  var _currencies = ["Food", "Item", "Clothes", "Both Food and Item", "Others"];
  String donorUsername = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController donationtitle = TextEditingController();

  TextEditingController donationname = TextEditingController();
  TextEditingController donationquantity = TextEditingController();
  TextEditingController description = TextEditingController();

  void donation() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    ///
    if (_formKey.currentState.validate()) {
      // print(_currentSelectedValue);
      // print(_currencies.indexOf(_currentSelectedValue));
      // var url = "http://192.168.254.106/phpPractice/mobile/Donationapi.php";
      // var response = await http.post(url, body: {
      //   'donorname': donorUsername,
      //   'donationname': donationname.text,
      //   'donationtype': (_currencies.indexOf(_currentSelectedValue)).toString(),
      //   'donationquantity': donationquantity.text,
      //   'description': description.text,
      //   'date': formattedDate
      // });
      // var data = json.decode(response.body);
      // if (data == "Success") {
      //   Navigator.push(
      //       context, MaterialPageRoute(builder: (context) => Home()));
      //   Fluttertoast.showToast(
      //       msg: "Donated",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.blue,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }
      Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (context) => Match(
                    donationNameMatch: donationname.text,
                    donationTypeMatch:
                        (_currencies.indexOf(_currentSelectedValue)).toString(),
                    donationQuantityMatch: donationquantity.text,
                    donationDescription: description.text,
                  )));
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
          return "Please Input Details";
        } else {
          return null;
        }
      },
      keyboardType: keyType,
      decoration: InputDecoration(
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.teal)),
          hintText: hintName,
          labelText: label,
          contentPadding: EdgeInsets.fromLTRB(10, 20, 0, 15)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Donation"),
        backgroundColor: kprimaryColor,
        automaticallyImplyLeading: false,
      ),
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
                    // _buildFoodDonFormField(
                    //     label: "Food Title", name: foodtitle),
                    _buildFoodDonFormField(
                      hintName: "e.g Canned Goods, Bottled Water etc..",
                      label: "Donation Name",
                      name: donationname,
                    ),
                    // SizedBox(height: 20),
                    // FormField<String>(
                    //   builder: (FormFieldState<String> state) {
                    //     return InputDecorator(
                    //       decoration: InputDecoration(
                    //         errorStyle: TextStyle(
                    //             color: Colors.redAccent, fontSize: 16.0),
                    //       ),
                    //       isEmpty: _currentSelectedValue == '',
                    //       child: DropdownButtonHideUnderline(
                    //         child: DropdownButton<String>(
                    //           hint: Text("Donation Type"),
                    //           value: _currentSelectedValue,
                    //           isDense: true,
                    //           onChanged: (String newValue) {
                    //             setState(() {
                    //               _currentSelectedValue = newValue;
                    //               state.didChange(newValue);
                    //             });
                    //           },
                    //           items: _currencies.map((String value) {
                    //             return DropdownMenuItem<String>(
                    //               value: value,
                    //               child: Text(value),
                    //             );
                    //           }).toList(),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    // ),
                    // SizedBox(height: 20),

                    // _buildFoodDonFormField(
                    //     label: "Donation Quanity",
                    //     keyType: TextInputType.number,
                    //     name: donationquantity),
                    // SizedBox(
                    //   height: 20.0,
                    // ),
                    // _buildFoodDonFormField(
                    //     label: "Description", lines: 4, name: description),
                    // SizedBox(
                    // height: 20.0,
                    // ),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonTheme(
                        height: 50.0,
                        child: RaisedButton(
                            onPressed: () {
                              donation();
                            },
                            color: kprimaryColor,
                            child: Text("Find Match",
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
