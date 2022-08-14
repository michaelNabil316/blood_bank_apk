import 'package:blood_bank/presentations/constants.dart';
import 'package:blood_bank/presentations/screens/aboutus.dart';
import 'package:blood_bank/presentations/screens/allchats.dart';
import 'package:blood_bank/presentations/screens/login_screen.dart';
import 'package:blood_bank/presentations/screens/one_post_notifi.dart';
import 'package:blood_bank/presentations/screens/posts.dart';
import 'package:blood_bank/presentations/screens/profile.dart';
import 'package:blood_bank/presentations/screens/search.dart';
import 'package:blood_bank/presentations/screens/sign_up.dart';
import 'package:blood_bank/presentations/screens/single_chat.dart';
import 'package:blood_bank/presentations/screens/user_profile.dart';
import 'package:blood_bank/presentations/screens/welcome_screen.dart';
import 'package:blood_bank/presentations/translation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'business_logic/cubit/bloc.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final pref = await SharedPreferences.getInstance();
  bool savedData() {
    if (pref.containsKey('key') == false) {
      return false;
    }
    return true;
  }

  runApp(MyApp(savedData: savedData()));
}

class MyApp extends StatelessWidget {
  final bool savedData;
  const MyApp({Key? key, this.savedData = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppBloc(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: Translation(),
        locale: const Locale('en'),
        fallbackLocale: const Locale('en'),
        theme: ThemeData(
            primaryColor: redColor,
            canvasColor: Colors.transparent,
            appBarTheme: const AppBarTheme(titleSpacing: 0.0)
            //accentColor: redColor,
            ),
        //for make app not open welcome screen again after login
        initialRoute: (savedData == true) ? HomePage.id : WelcomeScreen.id,
        routes: {
          WelcomeScreen.id: (context) => const WelcomeScreen(),
          LoginScreen.id: (context) => const LoginScreen(),
          SignUpScreen.id: (context) => const SignUpScreen(),
          HomePage.id: (context) => const HomePage(), //posts page

          AboutUsScreen.id: (context) => AboutUsScreen(),
          ProfileScreen.id: (context) => const ProfileScreen(),
          MessangerScreen.id: (context) => const MessangerScreen(),
          Search.id: (context) => const Search(),
          SingleChat.id: (context) => const SingleChat(),
          OnePostNotifi.id: (context) => const OnePostNotifi(),
          UserProfileScreen.id: (context) => UserProfileScreen(),
        },
      ),
    );
  }
}
