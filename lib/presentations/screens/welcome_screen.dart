import 'package:blood_bank/presentations/components/button_widget.dart';
import 'package:blood_bank/presentations/constants.dart';
import 'package:blood_bank/presentations/controller/app_language.dart';
import 'package:blood_bank/presentations/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';

import 'login_screen.dart';

final FirebaseMessaging _fcm = FirebaseMessaging.instance;

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  const WelcomeScreen({Key? key}) : super(key: key);
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

///**************************************************** this is for animation
class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late AnimationController controller2; //
  late Animation animation;
  late Animation animation2; //

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    controller2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 7));

    animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation2 = CurvedAnimation(parent: controller2, curve: Curves.bounceOut);
    controller.forward();
    controller2.forward();
    controller.addListener(() {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {});
    });
    controller2.addListener(() {
      if (!mounted) {
        return; // Just do nothing if the widget is disposed.
      }
      setState(() {});
    });
    _fcm.requestPermission();

    // _fcm.configure(
    //   onMessage: (Map<String, dynamic> message) async {},
    //   onLaunch: (Map<String, dynamic> message) async {},
    //   onResume: (Map<String, dynamic> message) async {},
    // );
  }

  @override
  Widget build(BuildContext context) {
    final myMedia = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        title: GetBuilder(
          init: AppLanguage(),
          builder: (AppLanguage controller) {
            return Container(
              height: 30,
              width: 90,
              padding: const EdgeInsets.only(left: 5, right: 5),
              decoration: const ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              child: DropdownButton(
                dropdownColor: Colors.white,
                items: const [
                  DropdownMenuItem(
                    child: Text('English'),
                    value: 'en',
                  ),
                  DropdownMenuItem(
                    child: Text('العربية'),
                    value: 'ar',
                  ),
                ],
                value: controller.appLocale,
                onChanged: (dynamic value) {
                  controller.changeLanguage(value);
                  Get.updateLocale(Locale(value));
                },
              ),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.topLeft,
          children: [
            Container(
              width: double.infinity,
              height: myMedia.height * 0.8,
              color: redColor,
            ),
            Container(
              width: myMedia.width * 0.5,
              height: double.infinity,
              color: Colors.white,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: myMedia.height * 0.5,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(100.0)),
                    color: Colors.white,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textDirection: TextDirection.ltr,
                        children: <Widget>[
                          const Text(
                            '  Blood Bank  ',
                            style: kWelcomeTextStyle,
                          ),
                          SizedBox(
                            child: Image.asset('assets/images/heart.PNG'),
                            height: animation2.value * myMedia.height * 0.1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: myMedia.height * 0.025,
                      ),
                      Hero(
                        tag: 'logo',
                        child: SizedBox(
                          height: animation.value * myMedia.height * 0.3,
                          child: Image.asset('assets/images/welcome.PNG'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: myMedia.height * 0.35,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100.0),
                        bottomLeft: Radius.circular(35.0)),
                    color: redColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myMedia.width * 0.2),
                        child: ButtonWidget(
                            Colors.white, 'sign in'.tr, redColor, () {
                          FirebaseDatabase.instance
                              .reference()
                              .child('Users')
                              .child('eK5DQt1Ws5MXanxk6X8xItDF04z2')
                              .once()
                              .then((DataSnapshot snapshot) {
                            var values = snapshot.value;
                          });

                          Navigator.pushNamed(context, LoginScreen.id);
                        }, myMedia.height * 0.065, myMedia.width * 0.5),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myMedia.width * 0.2),
                        child: ButtonWidget(
                            Colors.white, 'sign up'.tr, redColor, () {
                          Navigator.pushNamed(context, SignUpScreen.id);
                        }, myMedia.height * 0.065, myMedia.width * 0.5),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
