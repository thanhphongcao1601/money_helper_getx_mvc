import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';
import 'package:money_helper_getx_mvc/backup_module/view/backup_page.dart';
import 'package:money_helper_getx_mvc/setting_module/view/setting_page.dart';
import 'package:money_helper_getx_mvc/statistic_module/view/statistic_page.dart';
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
            //Get.updateLocale(const Locale('vi', 'VN'));
          },
          backgroundColor: Theme.of(context).colorScheme.secondary,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: Obx(
            () => buildBottomBar(appController.currentIndex.value, context)),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Get.changeTheme(
                    appController.isDarkMode.value
                        ? ThemeData(primarySwatch: Colors.blueGrey)
                        : ThemeData.dark(),
                  );
                  appController.isDarkMode.value =
                      !appController.isDarkMode.value;
                },
                icon: Obx(() => appController.isDarkMode.value
                    ? const FaIcon(FontAwesomeIcons.sun)
                    : const FaIcon(FontAwesomeIcons.moon))),
          ],
          centerTitle: true,
          title: Text(
            'appName'.tr,
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
        ),
        body: Obx(() => SafeArea(child: buildPageSelected())));
  }

  Widget buildPageSelected() {
    switch (appController.currentIndex.value) {
      case 0:
        return HomePage();
      case 1:
        return const StatisticPage();
      case 2:
        return const BackUpPage();
      case 3:
        return SettingPage();
      default:
        return HomePage();
    }
  }
}
