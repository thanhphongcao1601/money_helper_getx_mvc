import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:lottie/lottie.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/add_loan_module/add_loan_page.dart';
import 'package:money_helper_getx_mvc/module/add_record_module/add_record_page.dart';
import 'package:money_helper_getx_mvc/module/home_module/home_page.dart';
import 'package:money_helper_getx_mvc/module/loan_module/loan_page.dart';
import 'package:money_helper_getx_mvc/module/setting_module/setting_page.dart';
import 'package:money_helper_getx_mvc/module/statistic_module/statistic_page.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/widgets/bottom_nav_bar.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.purple,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (appController.currentPageIndex.value != 2) {
              Get.to(() => const AddRecordPage());
            } else {
              Get.to(() => const AddLoanPage());
            }
          },
          backgroundColor: AppColor.gold,
          child: const Icon(
            Icons.add,
            color: AppColor.darkPurple,
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: Obx(() => buildBottomBar(appController.currentPageIndex.value, context)),
        body: Obx(() => LoadingOverlay(
              progressIndicator: const CircularProgressIndicator(color: AppColor.gold),
              color: AppColor.darkPurple,
              isLoading: appController.isLoading.value,
              child: Container(color: AppColor.purple, child: SafeArea(child: buildPageSelected())),
            )));
  }

  Widget buildPageSelected() {
    switch (appController.currentPageIndex.value) {
      case 0:
        return const HomePage();
      case 1:
        if (appController.listRecord.value.isNotEmpty) {
          return const StatisticPage();
        }
        return Center(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/lotties/empty.json', width: 100),
            Text(
              'noData'.tr,
              style: const TextStyle(color: AppColor.gold),
            )
          ],
        ));
      case 2:
        return LoanPage();
      case 3:
        return const SettingPage();
      default:
        return const HomePage();
    }
  }
}
