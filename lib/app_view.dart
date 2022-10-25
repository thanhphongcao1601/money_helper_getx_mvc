import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';
import 'package:money_helper_getx_mvc/backup_module/view/backup_page.dart';
import 'package:money_helper_getx_mvc/setting_module/view/setting_page.dart';
import 'package:money_helper_getx_mvc/statistic_module/view/statistic_page.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'add_record_module/view/add_record_page.dart';
import 'home_module/controller/home_controller.dart';
import 'home_module/view/home_page.dart';
import 'ultis/widgets/bottom_nav_bar.dart';

// ignore: must_be_immutable
class AppPage extends StatelessWidget {
  AppPage({super.key});
  HomeController homeController = Get.put(HomeController());
  AppController appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    homeController.loadListRecord();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => const AddRecordPage());
          },
          backgroundColor: AppColor.gold,
          child: const Icon(Icons.add, color: AppColor.darkPurple,),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: Obx(
            () => buildBottomBar(appController.currentIndex.value, context)),
        body: Obx(() => Container(
          color: AppColor.purple,
          child: SafeArea(child: buildPageSelected()))));
  }

  Widget buildPageSelected() {
    switch (appController.currentIndex.value) {
      case 0:
        return const HomePage();
      case 1:
        return const StatisticPage();
      case 2:
        return BackUpPage();
      case 3:
        return const SettingPage();
      default:
        return const HomePage();
    }
  }
}
