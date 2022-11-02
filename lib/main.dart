import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/module/splash_screen_module/splash_page.dart';
import 'localization/languages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: const SplashPage(),
    );
  }
}
