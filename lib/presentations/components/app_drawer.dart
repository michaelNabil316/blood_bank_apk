import 'package:blood_bank/presentations/screens/aboutus.dart';
import 'package:blood_bank/presentations/screens/profile.dart';
import 'package:blood_bank/presentations/screens/search.dart';
import 'package:blood_bank/presentations/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants.dart';

//translation
import 'package:get/get.dart';

final _auth = FirebaseAuth.instance;

class AppDrawer extends StatefulWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: showSpinner
          ? const CircularProgressIndicator()
          : Drawer(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    const Image(
                      image: AssetImage('assets/images/giver.jpg'),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 15),
                    InkWell(
                      child: DrawerListTile(
                          title: 'Home'.tr, icon: Icons.home_outlined),
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    InkWell(
                      child: DrawerListTile(
                          title: 'Profile'.tr, icon: Icons.person),
                      onTap: () {
                        Navigator.of(context).pushNamed(ProfileScreen.id);
                      },
                    ),
                    InkWell(
                      child: DrawerListTile(
                          title: 'Search'.tr, icon: Icons.search_outlined),
                      onTap: () {
                        Navigator.of(context).pushNamed(Search.id);
                      },
                    ),
                    InkWell(
                      child: DrawerListTile(
                          title: 'About Us'.tr, icon: Icons.group),
                      onTap: () {
                        Navigator.of(context).pushNamed(AboutUsScreen.id);
                      },
                    ),
                    InkWell(
                      child: DrawerListTile(
                          title: 'Log Out'.tr, icon: Icons.logout),
                      onTap: () async {
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
    );
  }
}

class DrawerListTile extends StatelessWidget {
  //const DrawerListTile({ Key? key }) : super(key: key);
  final String title;
  final IconData icon;
  const DrawerListTile(
      {Key? key, this.title = 'No name', this.icon = Icons.error})
      : super(key: key);

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
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: redColor,
        ),
      ),
    );
  }
}
