import 'package:fido_project/alertDialog.dart';
import 'package:fido_project/constants/constantsVariable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fido_project/screens/DONATIONMATCH.dart';
import 'package:fido_project/screens/matchDonation.dart';
import 'package:fido_project/screens/globals.dart' as globals;

import 'dart:async';
import 'dart:typed_data';

class Home extends StatefulWidget {
  static const LOAD_CATEGORY_URL =
      'http://$myip/phpPractice/mobile/requestApi.php';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List _categoryList = List();
  List _list;
  List _categoryListDisplay;
  List _adminList;
  List _adminRequest;
  Future getRequestData() async {
    var response = await http.get(Home.LOAD_CATEGORY_URL);
    if (response.statusCode == 200) {
      setState(() {
        _categoryList = json.decode(response.body);
      });
      // print(categoryList);
      return _categoryList;
    }
    // return json.decode(response.body);
  }

/////
  void getAdminRequestData() async {
    var url = "http://$myip/phpPractice/mobile/adminHomeRequestApi.php";
    var response = await http.get(url);
    // var data = json.decode(response.body);
    setState(() {
      _adminRequest = json.decode(response.body);
    });
  }

//////
  Widget showImage(String thumbnail) {
    String placeholder =
        "iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==";
    if (thumbnail?.isEmpty ?? true)
      thumbnail = placeholder;
    else {
      switch (thumbnail.length % 4) {
        case 1:
          break; // this case can't be handled well, because 3 padding chars is illeagal.
        case 2:
          thumbnail = thumbnail + "==";
          break;
        case 3:
          thumbnail = thumbnail + "=";
          break;
      }
    }
    // final UriData data = Uri.parse(thumbnail).data;
    // print(data.isBase64); // Should print true
    // print(data.contentAsBytes()); // Would returns your image a Uint8List
    final _byteImage = Base64Decoder().convert(thumbnail);
    Widget image = Image.memory(
      _byteImage,
      width: 50,
      height: 20,
      gaplessPlayback: true,
      fit: BoxFit.fill,
    );
    return image;
  }

  Widget showImageB(String image) {
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
  void initState() {
    super.initState();

    getAdminRequestData();
    getRequestData().then((value) {
      setState(() {
        // categoryList.addAll(value);
        _categoryListDisplay = _categoryList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: Text("Organization"),
        //   backgroundColor: kprimaryColor,
        //   automaticallyImplyLeading: false,
        // ),
        body: Column(
      children: [
        Expanded(
            child: _categoryListDisplay == null
                ? Center(child: Text("Loading..."))
                : ListView.builder(
                    itemBuilder: (context, index) {
                      _list = _categoryListDisplay;
                      return index == 0
                          ? _searchBar()
                          : _listItem(_list, index - 1);
                    },
                    itemCount: _categoryListDisplay.length + 1,
                  ))
      ],
    ));
  }

  _searchBar() {
    return Padding(
        padding: EdgeInsets.only(left: 24, right: 24, top: 10),
        child: TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Search..",
              prefixIcon: Icon(Icons.search)),
          onChanged: (text) {
            text = text.toLowerCase();
            setState(() {
              _categoryListDisplay = _categoryList.where((i) {
                var orgName = i['orgName'].toLowerCase();
                return orgName.contains(text);
              }).toList();
            });
          },
        ));
  }

  _listItem(list, index) {
    return list[index]['statusDescription'] == "Approved" &&
            int.parse(list[index]['quantity']) > 0
        ? Container(
            margin: EdgeInsets.all(20.0),
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Column(children: [
                  showImageB(list[index]['images']),
                  ListTile(
                    subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10.0),
                          Text(
                              "${list[index]['orgName'] == null ? 'Admin' : list[index]['orgName']}",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 10.0),
                          Text("Request name :${list[index]['name']}"),
                          SizedBox(height: 10.0),
                          Text("Quantity : ${list[index]['quantity']}"),
                          SizedBox(height: 10.0),
                          Text("Details: ${list[index]['description']}"),

                          SizedBox(height: 10.0),
                          // Text("importance: ${list[index]['importance']}"),
                          Text("urgency: ${list[index]['Urgent']}"),
                          Text("Date: ${list[index]['requestDate']}"),
                          SizedBox(height: 10.0),
                          Row(
                            children: [
                              list[index]['orgName'] != null
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: ksecondaryColor,
                                      ),
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                                builder: (context) =>
                                                    MatchDonation(
                                                        orgRequestName:
                                                            list[index]['name'],
                                                        orgName: list[index]
                                                            ['orgName'],
                                                        orgDescription:
                                                            list[index]
                                                                ['description'],
                                                        requestID: list[index]
                                                            ['requestID'])));
                                        print(list[index]['description']);
                                      },
                                      child: Text("Donate",
                                          style:
                                              TextStyle(color: Colors.white)))
                                  : Container(),
                              SizedBox(width: 20.0),
                              // ElevatedButton(
                              //     onPressed: () {},
                              //     style: ElevatedButton.styleFrom(
                              //       primary: Colors.white, // background
                              //     ),
                              //     child: Icon(FontAwesomeIcons.solidHeart,
                              //         color: Colors.red)),
                            ],
                          )
                        ]),
                  ),
                ]),
              ),
            ),
          )
        : Text('');
  }
}
