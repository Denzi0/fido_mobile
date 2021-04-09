import 'dart:io';
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

class OrgRequests extends StatefulWidget {
  @override
  _OrgRequests createState() => _OrgRequests();
}

class _OrgRequests extends State<OrgRequests> {
  File imageFile;
  String imageData;
  final picker = ImagePicker();

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

  ///////
  TextEditingController checkedValue = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController quantity = TextEditingController();
  TextEditingController description = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isUrgent = false;

  static const ADD_CATEGORY_URL =
      "http://192.168.254.106/phpPractice/mobile/orgrequestapi.php";

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
      // var url = "http://192.168.254.106/phpPractice/mobile/orgrequestapi.php";
      var response = await http.post(ADD_CATEGORY_URL, body: {
        'images': imageData != null ? imageData : "",
        'orgname': orgname,
        'name': name.text,
        'quantity': quantity.text,
        'description': description.text,
        'isUrgent': isUrgent ? '0' : '1',
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
            msg: "Success",
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
        decoration: InputDecoration(labelText: label),
        keyboardType: keyType);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Organization Request"),
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
                    _buildOrgRequestFormField(
                        label: "Request Name", controllerName: name),
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
                        keyType: TextInputType.number,
                        lines: 4),
                    CheckboxListTile(
                      title:
                          Text("Is this an urgent Donation ? "), //    <-- label
                      value: isUrgent,
                      onChanged: (bool newValue) {
                        print(newValue);
                        setState(() {
                          isUrgent = newValue;
                        });
                      },
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
                            child: Text("Request",
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
