import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:blood_bank/presentations/components/button_widget.dart';
import 'package:blood_bank/presentations/components/error_message_alert.dart';
import 'package:blood_bank/presentations/screens/posts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//translation
import 'package:get/get.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String uid = '';
  String? email;
  String? password;
  String imageName = 'assets/images/logo.png';
  String? error;
  String? m1;
  String? m2;
  String? m3;
  bool showSpinner = false;
  var emailRegExp = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  bool isEmail = false;
  bool isPassword = false;

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    //gender no used yet
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign in'.tr),
        backgroundColor: redColor,
      ),
      body: SafeArea(
        child:
            // showSpinner? const Center(child: CircularProgressIndicator()):
            Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Image.asset(imageName),
                ),
              ),
              const SizedBox(height: 50.0),
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
                  hintText: 'Enter your password'.tr,
                  errorText: isPassword
                      ? 'password must be at least 8 digits'.tr
                      : null,
                ),
              ),
              const SizedBox(height: 24.0),
              BlocBuilder<AppBloc, AppState>(builder: (context, state) {
                return ButtonWidget(redColor, 'Log In'.tr, Colors.white,
                    () async {
                  if (!emailRegExp.hasMatch(email!)) {
                    errorAlertMessage(
                        context, 'email expression is not valid'.tr);
                    setState(() {
                      isEmail = true;
                    });
                  } else if (password!.length < 8) {
                    errorAlertMessage(
                        context, 'password must be at least 8 digits'.tr);
                    setState(() {
                      isPassword = true;
                    });
                  }
                  if (emailRegExp.hasMatch(email!) && password!.length > 7) {
                    setState(() {
                      showSpinner = true;
                    });
                    final pref = await SharedPreferences.getInstance();
                    if (pref.containsKey('key') == false) {
                      final userData = json.encode({'email': email});
                      pref.setString('key', userData);
                    }
                    try {
                      await _auth
                          .signInWithEmailAndPassword(
                              email: email!, password: password!)
                          .then((value) => {
                                setState(() {
                                  uid = _auth.currentUser!.uid;
                                  AppBloc.get(context).changeUserUID(uid);
                                  showSpinner = false;
                                }),
                                //setCurrentUserData(context);
                                Navigator.pushReplacementNamed(
                                    context, HomePage.id),
                              })
                          .onError((error, stackTrace) => {
                                setState(() {
                                  showSpinner = false;
                                }),
                                errorAlertMessage(
                                    context, 'email or password are wrong'.tr),
                              });
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        showSpinner = false;
                      });
                      return errorAlertMessage(
                          context, 'email or password are wrong'.tr);
                    } catch (err) {
                      setState(() {
                        showSpinner = false;
                      });
                      return errorAlertMessage(
                          context, 'email or password are wrong'.tr);
                    }
                  }
                }, myMedia.height * 0.08, myMedia.width * 0.5);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
