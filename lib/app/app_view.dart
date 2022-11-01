import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/add_record_module/view/add_record_page.dart';
import 'package:money_helper_getx_mvc/module/backup_module/view/backup_page.dart';
import 'package:money_helper_getx_mvc/module/home_module/view/home_page.dart';
import 'package:money_helper_getx_mvc/module/setting_module/view/setting_page.dart';
import 'package:money_helper_getx_mvc/module/statistic_module/view/statistic_page.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/widgets/bottom_nav_bar.dart';

// ignore: must_be_immutable
class AppPage extends StatelessWidget {
  AppPage({super.key});
  AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            backgroundColor: AppColor.purple,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Get.to(() => const AddRecordPage());
              },
              backgroundColor: AppColor.gold,
              child: const Icon(
                Icons.add,
                color: AppColor.darkPurple,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.endDocked,
            bottomNavigationBar: Obx(() =>
                buildBottomBar(appController.currentPageIndex.value, context)),
            body: Obx(() => Container(
                color: AppColor.purple,
                child: SafeArea(child: buildPageSelected()))));
  }

  Widget buildPageSelected() {
    switch (appController.currentPageIndex.value) {
      case 0:
        if (appController.listRecord.value.isNotEmpty) {
          return const HomePage();
        }
        return const Center(
          child: Text('No record'),
        );
      case 1:
        if (appController.listRecord.value.isNotEmpty) {
          return const StatisticPage();
        }
        return const Center(
          child: Text('No record'),
        );
      case 2:
        return const BackUpPage();
      case 3:
        return const SettingPage();
      default:
        return const HomePage();
    }
  }
}