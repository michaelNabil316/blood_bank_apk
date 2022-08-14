import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/presentations/components/button_widget.dart';
import 'package:blood_bank/presentations/components/dropdownlist.dart';
import 'package:blood_bank/presentations/components/edit_user_inf.dart';
import 'package:blood_bank/presentations/functions/citiesList.dart';
import 'package:blood_bank/presentations/screens/posts.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
//translation
import 'package:get/get.dart';

import '../constants.dart';

var arrList = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
var bloodType = 'A+';
var governmentItem = 'Alexandera';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  static String id = 'sign_up_screen';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  String uid = '';

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String confirmPaswrd = '0';
  int phone = 0;
  int age = 0;
  bool showSpinner = false;
  bool isFirstName = false;
  bool isLastName = false;
  bool isEmail = false;
  bool isPassword = false;
  bool isConfirmPaswrd = false;
  bool isPhone = false;
  bool isAge = false;

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    var appbloc = AppBloc.get(context);
    var newUserData = {
      'age': age,
      'government': governmentItem,
      'blood_type': bloodType,
      'email': email,
      'firstName': firstName,
      'phone': phone,
      'secondName': lastName,
      'user_imgURL':
          'https://preview.keenthemes.com/metronic-v4/theme/assets/pages/media/profile/profile_user.jpg'
    };
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Sign up'),
        backgroundColor: redColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: showSpinner
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(top: 34),
                        child: TextField(
                          onChanged: (value) {
                            firstName = value;
                          },
                          decoration: KTextFieldDecoration.copyWith(
                            hintText: 'first name'.tr,
                            errorText: isFirstName
                                ? 'can\'t be less than 3 digits'
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        onChanged: (value) {
                          lastName = value;
                        },
                        decoration: KTextFieldDecoration.copyWith(
                          hintText: 'last name',
                          errorText: isLastName
                              ? 'can\'t be less than 3 digits'.tr
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        onChanged: (value) {
                          email = value;
                        },
                        decoration: KTextFieldDecoration.copyWith(
                          hintText: 'Enter your email'.tr,
                          errorText: isEmail ? 'Not valid email form'.tr : null,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        decoration: KTextFieldDecoration.copyWith(
                          hintText: 'Enter password'.tr,
                          errorText: isPassword
                              ? 'password must be at least 8 digits'.tr
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        obscureText: true,
                        onChanged: (value) {
                          confirmPaswrd = value;
                        },
                        decoration: KTextFieldDecoration.copyWith(
                          hintText: 'Confirm password'.tr,
                          errorText: isConfirmPaswrd
                              ? 'Not the same as password'.tr
                              : null,
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      TextField(
                        onChanged: (value) {
                          phone = int.parse(value);
                        },
                        decoration: KTextFieldDecoration.copyWith(
                          hintText: 'Enter Your Phone Number'.tr,
                          errorText: isPhone
                              ? 'can\'t be less than 11 number'.tr
                              : null,
                        ),
                        keyboardType: TextInputType.number,
                        // Only numbers can be entered
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      SizedBox(
                        height: 60,
                        width: 250,
                        child: Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: TextField(
                                onChanged: (value) {
                                  age = int.parse(value);
                                },
                                decoration: KTextFieldDecoration.copyWith(
                                  hintText: 'age'.tr,
                                  errorText:
                                      isAge ? 'must be 18 or older'.tr : null,
                                ),
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[0-9]')),
                                ],
                                // Only numbers can be entered
                              ),
                            ),
                            const SizedBox(width: 10.0),
                            Text('Your blood type'.tr),
                            const SizedBox(width: 10.0),
                            Dropdownlist(
                              arrList: arrList,
                              dropdownValue: bloodType,
                              fun: (String? bloodtype) {
                                setState(() {
                                  bloodType = bloodtype!;
                                });
                              },
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Governorate: '.tr,
                            style: bloodTypeStyle,
                          ),
                          Dropdownlist(
                            arrList: governments,
                            dropdownValue: governmentItem,
                            containerWidth: 120,
                            fun: (String? bloodtype) {
                              setState(() {
                                governmentItem = bloodtype!;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 24.0),
                      ButtonWidget(redColor, 'Sign Up'.tr, Colors.white,
                          () async {
                        setState(() {
                          isFirstName = false;
                          isLastName = false;
                          isEmail = false;
                          isPassword = false;
                          isConfirmPaswrd = false;
                          isPhone = false;
                          isAge = false;
                        });

                        if (firstName.length < 3) {
                          //myAlertMessage(context, 'first name filed is require');
                          setState(() {
                            isFirstName = true;
                          });
                        }
                        if (lastName.length < 3) {
                          //myAlertMessage(context, 'last name filed is require');
                          setState(() {
                            isLastName = true;
                          });
                        }
                        if (!emailRegExp.hasMatch(email)) {
                          //myAlertMessage(context, 'email expression is not valied');
                          setState(() {
                            isEmail = true;
                          });
                        }
                        if (password.length < 8) {
                          //myAlertMessage(context, 'password must be at least 8 digits');
                          setState(() {
                            isPassword = true;
                          });
                        }
                        if (confirmPaswrd != password) {
                          //myAlertMessage(context, 'passwords filed are not the same');
                          setState(() {
                            isConfirmPaswrd = true;
                          });
                        }
                        if ('$phone'.length < 10) {
                          //myAlertMessage(context, 'phone number not 11 digits');
                          setState(() {
                            isPhone = true;
                          });
                        }
                        if (age < 18) {
                          //myAlertMessage(context, 'age must be 18 and older');
                          setState(() {
                            isAge = true;
                          });
                        }
                        if (firstName.length > 2 &&
                            lastName.length > 2 &&
                            password.length > 7 &&
                            confirmPaswrd == password &&
                            '$phone'.length > 9 &&
                            age > 17) {
                          setState(() {
                            showSpinner = true;
                          });
                          final pref = await SharedPreferences.getInstance();
                          final userData = json.encode({'email': email});
                          await _auth
                              .createUserWithEmailAndPassword(
                                  email: email, password: password)
                              .then((value) => {
                                    setState(
                                      () {
                                        uid = _auth.currentUser!.uid;
                                        appbloc.changeUserUID(uid);
                                      },
                                    ),

                                    //make user open his account imediately without login again
                                    if (pref.containsKey('key') == false)
                                      {pref.setString('key', userData)},
                                    //setCurrentUserData(context);
                                    FirebaseDatabase.instance
                                        .reference()
                                        .child('Users')
                                        .child(uid)
                                        .set(newUserData),
                                    Navigator.pushReplacementNamed(
                                        context, HomePage.id),
                                    setState(() {
                                      showSpinner = false;
                                    }),
                                  })
                              .catchError((error) {
                            setState(() {
                              showSpinner = false;
                            });
                            myAlertMessage(
                                context, 'This email is already exist'.tr);
                            //return;
                          });
                        }
                      }, myMedia.height * 0.08, myMedia.width * 0.5),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
