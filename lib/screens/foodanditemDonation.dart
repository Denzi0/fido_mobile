import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class FoodandItem extends StatefulWidget {
  @override
  _FoodandItemState createState() => _FoodandItemState();
}

class _FoodandItemState extends State<FoodandItem> {
  var _currentSelectedValue;
  var _currencies = ["BreakFast", "Lunch", "Dinner", "Proccessed Foods"];
  String donorUsername = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController foodtitle = TextEditingController();

  TextEditingController foodname = TextEditingController();
  TextEditingController foodquantity = TextEditingController();
  TextEditingController description = TextEditingController();

  // void donateFood() async {
  //   if (_formKey.currentState.validate()) {
  //     var url = "http://192.168.254.106/phpPractice/mobile/foodDonationapi.php";
  //     var response = await http.post(url, body: {
  //       'donorname': donorUsername,
  //       'foodtitle': foodtitle.text,
  //       'foodname': foodname.text,
  //       'foodtype': _currentSelectedValue,
  //       'foodquantity': foodquantity.text,
  //       'fooddescription': description.text
  //     });
  //     var data = json.decode(response.body);
  //     if (data == "Success") {
  //       Fluttertoast.showToast(
  //           msg: "Donated",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.blue,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //     }
  //   }
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        label: "Donation Name",
                        name: foodname,
                        hintName: "Milk,Food,Chair"),
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
                        name: foodquantity),
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
                              // donateFood();
                            },
                            color: kprimaryColor,
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
