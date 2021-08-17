import 'package:flutter/material.dart';
import 'package:canim/screens/login_screen.dart';
import 'package:canim/constants.dart';
import 'package:canim/widgets/buttonWidget.dart';
import 'package:canim/screens/sign_up.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:canim/controller/app_language.dart';
import 'package:flutter/cupertino.dart';

final FirebaseMessaging _fcm = FirebaseMessaging();

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

///**************************************************** this is for animation
class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  AnimationController controller;
  AnimationController controller2; //
  Animation animation;
  Animation animation2; //

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    controller2 =
        AnimationController(vsync: this, duration: Duration(seconds: 7));

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
    _fcm.requestNotificationPermissions();
    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        // print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        // print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        // print("onResume: $message");
      },
    );
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
              padding: EdgeInsets.only(left: 5, right: 5),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: BorderSide(width: 1.0, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
              ),
              child: DropdownButton(
                dropdownColor: Colors.white,
                items: [
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
                  decoration: BoxDecoration(
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
                          Text(
                            '  Blood Bank  ',
                            style: kWelcomeTextStyle,
                          ),
                          Container(
                            child: Image.asset('images/heart.PNG'),
                            height: animation2.value * myMedia.height * 0.1,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: myMedia.height * 0.025,
                      ),
                      Hero(
                        tag: 'logo',
                        child: Container(
                          height: animation.value * myMedia.height * 0.3,
                          child: Image.asset('images/welcome.PNG'),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: myMedia.height * 0.35,
                  decoration: BoxDecoration(
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
                            print(values);
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
