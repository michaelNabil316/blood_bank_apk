import 'dart:convert';
import 'package:blood_bank/business_logic/cubit/bloc.dart';
import 'package:blood_bank/business_logic/cubit/states.dart';
import 'package:blood_bank/presentations/components/button_widget.dart';
import 'package:blood_bank/presentations/components/custom_login_text.dart';
import 'package:blood_bank/presentations/screens/posts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final auth = FirebaseAuth.instance;
  String uid = '';
  String? error;
  bool showSpinner = false;

  static late double w, h;
  final formKey = GlobalKey<FormState>();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    h = MediaQuery.of(context).size.height;
    w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sign in'.tr),
        backgroundColor: redColor,
      ),
      body: BlocBuilder<AppBloc, AppState>(builder: (context, state) {
        final appBloc = AppBloc.get(context);
        return Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: h * 0.3,
                      child: Hero(
                        tag: 'logo',
                        child: Image.asset(imageName),
                      ),
                    ),
                    const SizedBox(height: 50.0),
                    CustomTextField(
                      ctrl: emailCtrl,
                      hintTitle: "Enter your email".tr,
                      havePerfixIcon: false,
                      validFun: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your email'.tr;
                        }
                        if (!emailRegExp.hasMatch(emailCtrl.text)) {
                          return 'email expression is not valid'.tr;
                        }
                        return null;
                      },
                      onChange: (v) {
                        if (v.length > 1) {
                          appBloc.changeErrorLogin("");
                        }
                      },
                    ),
                    const SizedBox(height: 10.0),
                    CustomTextField(
                      ctrl: passCtrl,
                      hintTitle: "Enter your password".tr,
                      havePerfixIcon: true,
                      validFun: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Enter your password'.tr;
                        }
                        if (value.length < 8) {
                          return 'password must be at least 8 digits'.tr;
                        }
                        return null;
                      },
                      onChange: (v) {
                        if (v.length > 1) {
                          appBloc.changeErrorLogin("");
                        }
                      },
                    ),
                    const SizedBox(height: 24.0),
                    Center(
                      child: Text(
                        appBloc.errorLogin,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    appBloc.showSpinner
                        ? const Center(child: CircularProgressIndicator())
                        : ButtonWidget(redColor, 'Log In'.tr, Colors.white,
                            () async {
                            FocusScope.of(context).requestFocus(FocusNode());
                            if (formKey.currentState!.validate()) {
                              final pref =
                                  await SharedPreferences.getInstance();
                              if (pref.containsKey('key') == false) {
                                final userData =
                                    json.encode({'email': emailCtrl.text});
                                pref.setString('key', userData);
                              }
                              final response = await appBloc.login(
                                  emailCtrl.text, passCtrl.text);
                              if (!response['error']) {
                                Navigator.pushReplacementNamed(
                                    context, HomePage.id);
                              }
                            }
                          }, h * 0.08, w * 0.5),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
