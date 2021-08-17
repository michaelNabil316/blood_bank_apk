import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:canim/utils/localStorage/local_storage.dart';

class AppLanguage extends GetxController {
  var appLocale = 'ar';

  @override
  void onInit() async {
    super.onInit();

    LocalStorage localStorage = LocalStorage();

    // ignore: unnecessary_null_comparison, unnecessary_statements
    appLocale = await localStorage.languageSelected == null
        // ignore: unnecessary_statements
        ? 'ar'
        : await localStorage.languageSelected;
    Get.updateLocale(Locale(appLocale));
    update();
  }

  void changeLanguage(String type) async {
    LocalStorage localStorage = LocalStorage();

    if (appLocale == type) {
      return;
    }
    if (type == 'ar') {
      appLocale = 'ar';
      localStorage.saveLanguageToDisk('ar');
    } else {
      appLocale = 'en';
      localStorage.saveLanguageToDisk('en');
    }
    update();
  }
}
