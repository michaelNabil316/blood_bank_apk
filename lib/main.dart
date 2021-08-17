import 'package:flutter/material.dart';
import 'package:canim/screens/welcome_screen.dart';
import 'package:canim/screens/login_screen.dart';
import 'package:canim/screens/aboutus.dart';
import 'package:canim/screens/sign_up.dart';
import 'package:canim/screens/profile.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:provider/provider.dart';
import 'package:canim/provider/providerClass.dart';
import 'package:canim/screens/posts.dart';
import 'package:canim/screens/allchats.dart';
import 'package:canim/screens/search.dart';
import 'package:canim/screens/singleChat.dart';
import 'package:canim/screens/onePostNotifi.dart';
import 'package:canim/screens/userProfile.dart';

//translation
import 'package:get/get.dart';
import 'package:canim/translation.dart';
import 'package:get_storage/get_storage.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  //await GetStorage.init();
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();
  bool savedData() {
    if (pref.containsKey('key') == false) {
      return false;
    }
    return true;
  }

  runApp(MyApp(savedData()));
}

class MyApp extends StatelessWidget {
  final savedData;
  MyApp(this.savedData);
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyData(),
      child: GetMaterialApp(
          debugShowCheckedModeBanner: false,
          translations: Translation(),
          locale: Locale('en'),
          fallbackLocale: Locale('en'),
          theme: ThemeData(
              primaryColor: redColor, canvasColor: Colors.transparent),
          //for make app not open welcome screen again after login
          initialRoute: WelcomeScreen.id, //(savedData == true) ? HomePage.id :
          routes: {
            WelcomeScreen.id: (context) => WelcomeScreen(),
            LoginScreen.id: (context) => LoginScreen(),
            SignUpScreen.id: (context) => SignUpScreen(),
            HomePage.id: (context) => HomePage(), //posts page
            AboutUsScreen.id: (context) => AboutUsScreen(),
            ProfileScreen.id: (context) => ProfileScreen(),
            MessangerScreen.id: (context) => MessangerScreen(),
            Search.id: (context) => Search(),
            SingleChat.id: (context) => SingleChat(),
            OnePostNotifi.id: (context) => OnePostNotifi(),
            UserProfileScreen.id: (context) => UserProfileScreen(),
          }),
    );
  }
}
