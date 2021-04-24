import 'dart:io';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fido_project/screens/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'globals.dart' as globals;

class OrgRequests extends StatefulWidget {
  @override
  _OrgRequests createState() => _OrgRequests();
}

class _OrgRequests extends State<OrgRequests> {
  //
  List suggestionList = [
    "Noodles",
    "Bottled Water",
    "Pencil",
    "Rice",
    "Canned Sardines",
    "Canned Tuna",
    "Canned Soup",
    "Blanket",
    "Pillow",
    "Shirt",
    "Jeans",
    "Pants",
    "Tissue",
  ];
  //
  File imageFile;
  String imageData;
  final picker = ImagePicker();
  var _currentSelectedValue;
  var _currentSelectedValueImportance;
  var _currentSelectedValueUrgency;

  var _currencies = ["Food", "Item", "Clothes", "Both Food and Item", "Others"];
  var _currenciesImportance = [
    "For people in needs",
    "House Fire victims",
    "Earthquake victims",
    "Flood and flashflood victims",
    "Typhoon victims",
  ];

  var _currenciesUrgency = [
    "Not Urgent",
    "Urgent",
  ];
  // current date time
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String currentdate = formatter.format(now);
  // current date time
  //get orgname
  String orgname = "";
  Future getOrgname() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      orgname = preferences.getString('orgname');
    });
  }

  @override
  void initState() {
    super.initState();
    getOrgname();
  }

  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  ///////
  ///
  TextEditingController checkedValue = TextEditingController();
  var name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController description = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static const ADD_CATEGORY_URL =
      "http://$myip/phpPractice/mobile/orgrequestapi.php";

  choiceImage() async {
    var pickedImage = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxHeight: 480,
        maxWidth: 640,
        imageQuality: 25);
    if (pickedImage != null) {
      setState(() {
        imageFile = File(pickedImage.path);
      });
      imageData = base64Encode(imageFile.readAsBytesSync());

      return imageData;
    } else {
      return null;
    }
  }

  showImage(String image) {
    return Image.memory(base64Decode(image));
  }

  Future orgRequests() async {
    if (_formKey.currentState.validate()) {
      print(_currenciesImportance.indexOf(_currentSelectedValueImportance));
      // var url = "http://192.168.254.106/phpPractice/mobile/orgrequestapi.php";
      var response = await http.post(ADD_CATEGORY_URL, body: {
        'images': imageData != null ? imageData : "",
        'orgname': orgname,
        'name': name.text,
        'type': _currentSelectedValue.toString(),
        'quantity': quantity.text,
        'description': description.text,
        // 'importance':
        //     _currenciesImportance.indexOf(_currentSelectedValueImportance) > 0
        //         ? '10'
        //         : '0',
        // (_currenciesUrgency.indexOf(_currentSelectedValueUrgency) +
        // _currenciesImportance.indexOf(_currentSelectedValueImportance))
        'isUrgent': (_currenciesUrgency.indexOf(_currentSelectedValueUrgency) +
                _currenciesImportance.indexOf(_currentSelectedValueImportance))
            .toString(),

        'daterequest': currentdate
      });

      // if (response.statusCode == 200) {
      //   print(response.body);
      //   Fluttertoast.showToast(
      //       msg: "Success",
      //       toastLength: Toast.LENGTH_SHORT,
      //       gravity: ToastGravity.CENTER,
      //       timeInSecForIosWeb: 1,
      //       backgroundColor: Colors.blue,
      //       textColor: Colors.white,
      //       fontSize: 16.0);
      // }

      var data = json.decode(response.body);
      if (data == "Success") {
        Fluttertoast.showToast(
            msg: "Request Sent",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  Widget _buildOrgRequestFormField(
      {String label,
      TextEditingController controllerName,
      TextInputType keyType,
      String hint,
      int lines}) {
    return TextFormField(
        maxLines: lines,
        controller: controllerName,
        validator: (e) {
          if (e.isEmpty) {
            return "Please input Field";
          } else {
            return null;
          }
        },
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
        ),
        keyboardType: keyType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Organization Donation Request"),
          backgroundColor: kprimaryColor,
          automaticallyImplyLeading: false),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoCompleteTextField(
                        // validator: _validateEmail,
                        controller: name,
                        itemSubmitted: (item) {
                          name.text = item;
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
                    // _buildOrgRequestFormField(
                    //     hint: "e.g Canned Goods, Bottled Water etc..",
                    //     label: "Donation Request",
                    //     controllerName: name),
                    SizedBox(height: 10.0),

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
                              hint: Text("Type"),
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
                    SizedBox(height: 10.0),

                    _buildOrgRequestFormField(
                        label: "Quantity",
                        controllerName: quantity,
                        keyType: TextInputType.number),

                    // _buildOrgRequestFormField(
                    //     label: "Item Name", controllerName: itemname),
                    // _buildOrgRequestFormField(
                    //     label: "Item Type", controllerName: itemtype),
                    // _buildOrgRequestFormField(
                    //     label: "Item Quantity",
                    //     controllerName: itemquantity,
                    //     keyType: TextInputType.number),
                    _buildOrgRequestFormField(
                        label: "Description",
                        controllerName: description,
                        hint: "Input Donation Request Details...",
                        keyType: TextInputType.number,
                        lines: 4),

                    ///Priotization
                    ///Priotization
                    SizedBox(height: 20.0),
                    Text("Purpose:"),
                    SizedBox(height: 10.0),

                    ///Priotization
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                          ),
                          isEmpty: _currentSelectedValueImportance == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Purpose"),
                              value: _currentSelectedValueImportance,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _currentSelectedValueImportance = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _currenciesImportance.map((String value) {
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

                    ///Priotization
                    ///Priotization
                    ///Priotization

                    // CheckboxListTile(
                    //   title: Text("Urgent Request ?      "), //    <-- label
                    //   value: isUrgent,
                    //   onChanged: (bool newValue) {
                    //     print(newValue);
                    //     setState(() {
                    //       isUrgent = newValue;
                    //     });
                    //   },
                    // ),

                    //Urgency
                    //Urgency
                    //Urgency
                    SizedBox(height: 20.0),
                    Text("Urgency: "),
                    SizedBox(height: 10.0),
                    FormField<String>(
                      builder: (FormFieldState<String> state) {
                        return InputDecorator(
                          decoration: InputDecoration(
                            errorStyle: TextStyle(
                                color: Colors.redAccent, fontSize: 16.0),
                          ),
                          isEmpty: _currentSelectedValueUrgency == '',
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Urgency"),
                              value: _currentSelectedValueUrgency,
                              isDense: true,
                              onChanged: (String newValue) {
                                setState(() {
                                  _currentSelectedValueUrgency = newValue;
                                  state.didChange(newValue);
                                });
                              },
                              items: _currenciesUrgency.map((String value) {
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
                    //Urgency
                    //Urgency
                    //
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
                    SizedBox(height: 10.0),
                    SizedBox(
                      width: double.infinity,
                      child: ButtonTheme(
                        height: 50.0,
                        child: RaisedButton(
                            onPressed: () {
                              orgRequests();
                            },
                            color: kprimaryColor,
                            child: Text("Request Donation",
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
