import 'package:get/get.dart';
import 'package:canim/utils/ar.dart';
import 'package:canim/utils/en.dart';

class Translation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
      };
}
