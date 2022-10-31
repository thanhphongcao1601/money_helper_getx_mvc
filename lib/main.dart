import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';
import 'package:money_helper_getx_mvc/app_view.dart';
import 'package:money_helper_getx_mvc/module/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/module/statistic_module/controller/statistic_controller.dart';

import 'localization/languages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final appController = Get.put(AppController());
  final homeController = Get.lazyPut(()=>HomeController());
  final statisticController = Get.put(StatisticController());

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    appController.getListRecordFromPrefs();
    return GetMaterialApp(
      translations: Languages(),
      locale: Get.deviceLocale,
      fallbackLocale: const Locale('en', 'US'),
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      home: AppPage(),
    );
  }
}
