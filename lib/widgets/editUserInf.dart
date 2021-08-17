import 'package:flutter/material.dart';
import 'package:canim/widgets/buttonWidget.dart';
import 'package:canim/widgets/dropdownlist.dart';
import 'package:canim/constants.dart';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/services.dart';

import 'package:canim/provider/providerClass.dart';
import 'package:provider/provider.dart';

import 'package:canim/functions/citiesList.dart';

//translation
import 'package:get/get.dart';

var arrList = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
var bloodType = 'A+';
var governmentItem = 'Alexandera';
String uid = '';
String firstName = '';
String lastName = '';
String email = '';
String imgUrl =
    'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg';
int phone = 0;
int age = 0;

class EditUserData extends StatefulWidget {
  static String id = 'EditUserData';
  @override
  _EditUserDataState createState() => _EditUserDataState();
}

class _EditUserDataState extends State<EditUserData> {
  bool showSpinner = false;
  var emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool isFirstName = false;
  bool isLastName = false;
  bool isEmail = false;
  bool isPhone = false;
  bool isAge = false;
  bool firstBuild = true;

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    final myProvider = Provider.of<MyData>(context, listen: false);
    if (firstBuild) {
      setState(() {
        uid = myProvider.uid;
        firstName = myProvider.firstName;
        lastName = myProvider.lastName;
        email = myProvider.email;
        phone = myProvider.phone;
        age = myProvider.age;
        imgUrl = myProvider.imgURL;
        firstBuild = false;
      });
    }

    var newUserData = {
      'age': age,
      'blood_type': bloodType,
      'email': email,
      'firstName': firstName,
      'phone': phone,
      'secondName': lastName,
      'user_imgURL': imgUrl,
      'chats': myProvider.chats,
      'Notification': myProvider.notification,
      'SavedPosts': myProvider.savedPosts,
      'government': governmentItem,
    };
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)), //this right here
      child: Container(
        height: myMedia.height * 0.6,
        width: myMedia.width * 0.9,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 34),
                child: TextFormField(
                  initialValue: myProvider.firstName,
                  onChanged: (value) {
                    firstName = value;
                  },
                  decoration: KTextFieldDecoration.copyWith(
                    hintText: 'first name'.tr,
                    errorText:
                        isFirstName ? 'can\'t be less than 3 digits'.tr : null,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: myProvider.lastName,
                //controller: TextEditingController()..text = myProvider.lastName,
                onChanged: (value) {
                  lastName = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                  hintText: 'last name'.tr,
                  errorText:
                      isLastName ? 'can\'t be less than 3 digits'.tr : null,
                ),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: myProvider.email,
                //controller: TextEditingController()..text = myProvider.email,
                onChanged: (value) {
                  email = value;
                },
                decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Enter contact email'.tr,
                    errorText: isEmail ? 'Not valid email form'.tr : null,
                    labelText: 'contact email NOT sign in email'.tr),
              ),
              SizedBox(height: 10.0),
              TextFormField(
                initialValue: '${myProvider.phone}',
                //..text = '${myProvider.phone}',
                onChanged: (value) {
                  setState(() {
                    phone = int.parse(value);
                  });
                },
                decoration: KTextFieldDecoration.copyWith(
                  hintText: 'Enter Your Phone Number'.tr,
                  errorText:
                      isPhone ? 'can\'t be less than 11 number'.tr : null,
                ),
                keyboardType: TextInputType.number,
                // Only numbers can be entered
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
              ),
              SizedBox(height: 10.0),
              Container(
                height: 60,
                width: 250,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                        initialValue: '${myProvider.age}',
                        onChanged: (value) {
                          setState(() {
                            age = int.parse(value);
                          });
                        },
                        decoration: KTextFieldDecoration.copyWith(
                          hintText: 'age',
                          errorText: isAge ? 'must be 18 or older'.tr : null,
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        // Only numbers can be entered
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text('blood type'.tr),
                    SizedBox(width: 10.0),
                    Dropdownlist(
                      arrList: arrList,
                      dropdownValue: bloodType,
                      fun: (String bloodtype) {
                        setState(() {
                          bloodType = bloodtype;
                        });
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Governorate: ',
                    style: bloodTypeStyle,
                  ),
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
              SizedBox(height: 24.0),
              ButtonWidget(redColor, 'Update'.tr, Colors.white, () async {
                setState(() {
                  isFirstName = false;
                  isLastName = false;
                  isEmail = false;
                  isPhone = false;
                  isAge = false;
                });

                if (firstName.length < 3) {
                  myAlertMessage(context, 'first name filed is require'.tr);
                  setState(() {
                    isFirstName = true;
                  });
                } else if (lastName.length < 3) {
                  myAlertMessage(context, 'last name filed is require'.tr);
                  setState(() {
                    isLastName = true;
                  });
                } else if (!emailRegExp.hasMatch(email)) {
                  myAlertMessage(context, 'email expression is not valid'.tr);
                  setState(() {
                    isEmail = true;
                  });
                } else if ('$phone'.length < 10) {
                  myAlertMessage(context, 'phone number not 11 digits'.tr);
                  setState(() {
                    isPhone = true;
                  });
                } else if (age < 18) {
                  myAlertMessage(context, 'age must be 18 and older'.tr);
                  setState(() {
                    isAge = true;
                  });
                }
                if (firstName.length > 2 &&
                    lastName.length > 2 &&
                    '$phone'.length > 10 &&
                    age > 17) {
                  setState(() {
                    showSpinner = true;
                  });

                  final response = FirebaseDatabase.instance
                      .reference()
                      .child('Users')
                      .child(uid)
                      .set(newUserData);
                  //try response.whenComplete
                  if (response != null) {
                    Navigator.pop(context);
                    setState(() {
                      showSpinner = false;
                    });
                  } else {
                    setState(() {
                      showSpinner = false;
                    });
                  }
                }
              }, myMedia.height * 0.08, myMedia.width * 0.5),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> myAlertMessage(BuildContext context, String message) {
  return showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('An error'.tr),
      content: Text('$message'),
      actions: [
        FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text('Okay'.tr))
      ],
    ),
  );
}
