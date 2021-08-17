import 'package:flutter/material.dart';
import 'package:canim/widgets/buttonWidget.dart';
import 'package:canim/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:canim/screens/posts.dart';
import 'package:provider/provider.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:canim/screens/posts.dart';
//translation
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  String uid = '';
  String email;
  String password;
  String imageName = 'images/logo.png';
  String error;
  String m1;
  String m2;
  String m3;
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
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image.asset(imageName),
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                TextField(
                  onChanged: (value) {
                    email = value;
                  },
                  decoration: KTextFieldDecoration.copyWith(
                    hintText: 'Enter your email'.tr,
                    errorText: isEmail ? 'Not valid email form'.tr : null,
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
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
                SizedBox(
                  height: 24.0,
                ),
                ButtonWidget(redColor, 'Log In'.tr, Colors.white, () async {
                  if (!emailRegExp.hasMatch(email)) {
                    errorAlertMessage(
                        context, 'email expression is not valid'.tr);
                    setState(() {
                      isEmail = true;
                    });
                  } else if (password.length < 8) {
                    errorAlertMessage(
                        context, 'password must be at least 8 digits'.tr);
                    setState(() {
                      isPassword = true;
                    });
                  }
                  if (emailRegExp.hasMatch(email) && password.length > 7) {
                    setState(() {
                      showSpinner = true;
                    });
                    final pref = await SharedPreferences.getInstance();
                    if (pref.containsKey('key') == false) {
                      final userData = json.encode({'email': email});
                      pref.setString('key', userData);
                    }
                    final user = await _auth
                        .signInWithEmailAndPassword(
                            email: email, password: password)
                        .catchError((error) {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: Text('An error'.tr),
                          content: Text('email or password are wrong'.tr),
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.of(ctx).pop();
                                },
                                child: Text('Okay'.tr))
                          ],
                        ),
                      );
                    });
                    if (user != null) {
                      setState(() {
                        uid = _auth.currentUser.uid;
                        Provider.of<MyData>(context, listen: false)
                            .changeUserUID(uid);
                      });
                      //setCurrentUserData(context);
                      Navigator.pushReplacementNamed(context, HomePage.id);
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
      ),
    );
  }
}

Future<dynamic> errorAlertMessage(BuildContext context, String message) {
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
