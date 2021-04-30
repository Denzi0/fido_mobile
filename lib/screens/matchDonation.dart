import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fido_project/screens/home.dart';
import 'package:fido_project/screens/match.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class MatchDonation extends StatefulWidget {
  String requestID;
  String orgRequestName;

  String orgDescription;
  String orgName;
  MatchDonation(
      {Key key,
      @required this.orgRequestName,
      @required this.requestID,
      @required this.orgDescription,
      @required this.orgName})
      : super(key: key);
  @override
  _MatchDonationState createState() => _MatchDonationState(
      this.requestID, this.orgDescription, this.orgName, this.orgRequestName);
}

class _MatchDonationState extends State<MatchDonation> {
  String orgRequestName;
  String requestID;

  String orgDescription;
  String orgName;
  _MatchDonationState(
      this.requestID, this.orgDescription, this.orgName, this.orgRequestName);

  var _currencies = ["Food", "Item", "Clothes", "Both Food and Item", "Others"];
  String donorUsername = "";

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // TextEditingController donationtitle = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  TextEditingController donationname = TextEditingController();
  TextEditingController donationquantity = TextEditingController();
  TextEditingController description = TextEditingController();
  var _currentSelectedValue = "Others";
  List suggestionList = [
    "Noodles",
    "Bottled Water",
    "Pencil",
    "Rice",
    "Canned Sardines",
    "Canned Tuna",
    "Canned Soup",
    "Blanket",
    "Book-educational",
    "Book-magazines",
    "Book-novel",
    "Pillow",
    "Shirt",
    "Jeans",
    "Pants",
    "Tissue",
  ];

  ///
  File _imageFile;
  String imageData;
  final picker = ImagePicker();

  //////////
  choiceImage() async {
    var pickedImage = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 25);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(_imageFile.readAsBytesSync());

      return imageData;
    } else {
      return null;
    }
  }

  ////
  showImage(String image) {
    return Image.memory(base64Decode(image));
  }

  ////
  void food() async {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    ///
    if (_formKey.currentState.validate()) {
      var url = "http://$myip/phpPractice/mobile/donationHomeApi.php";
      var response = await http.post(url, body: {
        'orgID': requestID,
        'donorname': donorUsername,
        'donationname': donationname.text,
        'donationtype': (_currencies.indexOf(_currentSelectedValue)).toString(),
        'donationquantity': donationquantity.text,
        'description': description.text,
        'donationImages': imageData != null ? imageData : "",
        'date': formattedDate,
      });
      var data = json.decode(response.body);
      if (data == "Success") {
        Fluttertoast.showToast(
            msg: "Donated to Organization",
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
    setState(() {
      donationname.text = orgRequestName;
      orgRequestName == "Noodles" ||
              orgRequestName == "Canned Sardines" ||
              orgRequestName == "Canned Tuna" ||
              orgRequestName == "Canned Soup" ||
              orgRequestName == "Bottled Water" ||
              orgRequestName == "Rice"
          ? _currentSelectedValue = "Food"
          : _currentSelectedValue = "Item";
    });
    print(donorUsername);
    print(orgDescription);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text("Donor Donation"), backgroundColor: kprimaryColor),
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
                    AutoCompleteTextField(
                        // validator: _validateEmail,
                        controller: donationname,
                        itemSubmitted: (item) {
                          donationname.text = item;
                        },
                        // clearOnSubmit: false,
                        key: key,
                        decoration: InputDecoration(
                          hintText: "e.g Canned Goods, Bottled Water etc..",
                        ),
                        clearOnSubmit: false,
                        suggestions: suggestionList,
                        itemBuilder: (context, item) {
                          return Container(
                              padding: EdgeInsets.all(20.0),
                              child: Row(
                                children: [Text(item)],
                              ));
                        },
                        itemSorter: (a, b) {
                          return a.compareTo(b);
                        },
                        itemFilter: (item, query) {
                          return item
                              .toLowerCase()
                              .startsWith(query.toLowerCase());
                        }),

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
                      label: "Description",
                      lines: 4,
                      name: description,
                      hintName: 'Details of your donation..',
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    IconButton(
                        icon: Icon(FontAwesomeIcons.image),
                        onPressed: () {
                          // uploadImage();
                          choiceImage();
                        }),

                    imageData == null
                        ? Text('No image Selected')
                        : Container(
                            height: 200.0,
                            width: double.infinity,
                            child: showImage(imageData),
                          ),
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
    // initialValue: initialString,
    controller: name,
    maxLines: lines,
    // initialValue: "he",
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
