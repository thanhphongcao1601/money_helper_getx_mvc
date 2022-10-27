import 'dart:ui';

import 'package:get/get.dart';

class AppController extends GetxController {
  final isDarkMode = false.obs;
  RxInt currentIndex = 0.obs;
  RxString currentLanguageCode = 'English'.obs;

  dynamic changePage(int? newIndex) {
    currentIndex.value = newIndex!;
  }

  List<String> listLangue =[
    'Tiếng Việt',
    'English',
  ];

  Map<String,String> listMapLanguageAndCode = {
    'Tiếng Việt' : 'vi',
    'English' : 'en'
  };

  changeLanguage(String language){
    var code = listMapLanguageAndCode[language]!;
    currentLanguageCode.value = language;
    Get.updateLocale(Locale(code));
  }
}
