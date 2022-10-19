import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/add_record_module/view/add_record_page.dart';
import 'package:money_helper_getx_mvc/statistic_module/view/statistic_page.dart';
import 'home_module/controller/home_controller.dart';
import 'home_module/view/home_page.dart';
import 'ultis/constants/constant.dart';
import 'ultis/widgets/bottom_nav_bar.dart';

// ignore: must_be_immutable
class AppPage extends StatelessWidget {
  AppPage({super.key});
  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    homeController.loadListRecord();
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(const AddRecordPage());
          },
          backgroundColor: const Color(AppColor.yellow),
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: Obx(()=> buildBottomBar(homeController.currentIndex.value)),
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Quản lý chi tiêu',
            style: TextStyle(color: Colors.black),
          ),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                  colors: <Color>[
                    Color(AppColor.pink),
                    Color(AppColor.yellow)
                  ]),
            ),
          ),
        ),
        body: Obx(()=> SafeArea(child: homeController.currentIndex.value == 0 ? HomePage() : const StatisticPage())));
  }
}
