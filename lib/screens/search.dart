import 'package:flutter/material.dart';
import 'package:canim/widgets/user_item.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:canim/widgets/dropdownlist.dart';
import 'package:canim/widgets/buttonWidget.dart';
import 'package:canim/constants.dart';
import 'package:canim/functions/citiesList.dart';
//translation
import 'package:get/get.dart';

var bloodList = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
var bloodItem = 'A+';
var governmentItem = 'Alexandera';

class Search extends StatefulWidget {
  static String id = 'search';

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool searchAppear = false;
  String bloodItem = 'A+';

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 230, 230, 230),
      appBar: AppBar(
        title: Text('Search'.tr),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30, bottom: 20),
                child: Center(
                  child: Text('Search for user'.tr,
                      style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: redColor)),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: myMedia.width * 0.1, bottom: myMedia.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'blood type:'.tr,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: myMedia.width * 0.05),
                    Dropdownlist(
                      arrList: bloodList,
                      dropdownValue: bloodItem,
                      fun: (String bloodtype) {
                        setState(() {
                          bloodItem = bloodtype;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: myMedia.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Governorate: '.tr,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        )),
                    Dropdownlist(
                      arrList: governments,
                      dropdownValue: governmentItem,
                      containerWidth: 120,
                      fun: (String bloodtype) {
                        setState(() {
                          governmentItem = bloodtype;
                        });
                      },
                    ),
                  ],
                ),
              ),
              ButtonWidget(redColor, 'Search'.tr, Colors.white, () async {
                setState(() {
                  searchAppear = true;
                });
              }, myMedia.height * 0.04, myMedia.width * 0.5),
              SizedBox(
                height: myMedia.height * 0.13,
              ),
              searchAppear
                  ? StreamBuilder(
                      stream: FirebaseDatabase()
                          .reference()
                          .child('Users')
                          .orderByChild('blood_type')
                          .equalTo(bloodItem)
                          .onValue,
                      builder: (context, snapshot) {
                        List<UserItem> mypostsList = [];
                        final List<Widget> emptyList = [
                          Center(
                              child: Text('No users with this blood type'.tr))
                        ];
                        var response;
                        if (snapshot.hasData)
                          response = snapshot.data.snapshot.value;
                        if (snapshot.hasData && response != null) {
                          for (var key in response.keys) {
                            if (response[key]['government'] == governmentItem) {
                              final newItem = UserItem(
                                name:
                                    '${response[key]['firstName']} ${response[key]['secondName']}',
                                age: response[key]['age'],
                                bloodType: response[key]['blood_type'],
                                email: response[key]['email'],
                                img: response[key]['user_imgURL'],
                                userID: key,
                              );
                              mypostsList.add(newItem);
                            }
                          }
                          return ListView(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            reverse: true,
                            children: mypostsList.length != 0
                                ? mypostsList
                                : emptyList,
                          );
                        } else {
                          return Padding(
                            padding:
                                EdgeInsets.only(top: myMedia.height * 0.25),
                            child: Center(
                                child:
                                    Text('No users with this blood type'.tr)),
                          );
                        }
                      })
                  : Text('click search to filter'.tr)
            ],
          ),
        ),
      ),
    );
  }
}
