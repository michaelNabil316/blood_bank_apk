import 'package:canim/screens/welcome_screen.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/material.dart';
import 'package:canim/constants.dart';
import 'package:canim/screens/aboutus.dart';
import 'package:canim/screens/profile.dart';
import 'package:canim/screens/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
//translation
import 'package:get/get.dart';

final _auth = FirebaseAuth.instance;

class AppDrawer extends StatefulWidget {
  //const AppDrawer({ Key? key }) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                Image(
                  image: AssetImage('images/giver.jpg'),
                  //height: MediaQuery.of(context).size.height * 0.25,
                  width: double.infinity,
                ),
                SizedBox(height: 15),
                FlatButton(
                  child: DrawerListTile(
                      title: 'Home'.tr, icon: Icons.home_outlined),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child:
                      DrawerListTile(title: 'Profile'.tr, icon: Icons.person),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ProfileScreen.id);
                  },
                ),
                FlatButton(
                  child: DrawerListTile(
                      title: 'Search'.tr, icon: Icons.search_outlined),
                  onPressed: () {
                    Navigator.of(context).pushNamed(Search.id);
                  },
                ),
                FlatButton(
                  child:
                      DrawerListTile(title: 'About Us'.tr, icon: Icons.group),
                  onPressed: () {
                    Navigator.of(context).pushNamed(AboutUsScreen.id);
                  },
                ),
                FlatButton(
                  child:
                      DrawerListTile(title: 'Log Out'.tr, icon: Icons.logout),
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    await _auth.signOut();
                    final pref = await SharedPreferences.getInstance();
                    if (pref.containsKey('key') == true) {
                      var k = pref.getKeys();
                      for (var i in k) {
                        pref.remove(i);
                      }
                    }
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        WelcomeScreen.id, (route) => false);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  //const DrawerListTile({ Key? key }) : super(key: key);
  final String title;
  final IconData icon;
  DrawerListTile({this.title, this.icon});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
        color: redColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: redColor,
        ),
      ),
    );
  }
}
