import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

Widget buildBottomBar(int currentIndex, BuildContext context) {
  AppController appController = Get.find<AppController>();
  return BubbleBottomBar(
    backgroundColor: AppColor.darkPurple,
    opacity: .2,
    currentIndex: currentIndex,
    onTap: appController.changePage,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    elevation: 8,
    fabLocation: BubbleBottomBarFabLocation.end,
    hasNotch: true,
    hasInk: true,
    inkColor: AppColor.gold,
    items: <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: AppColor.gold,
          icon: const Icon(
            Icons.access_time,
            color: AppColor.gold,
          ),
          activeIcon: const Icon(
            Icons.access_time,
          ),
          title: Text("bottomNav.daily".tr)),
      BubbleBottomBarItem(
          backgroundColor: AppColor.gold,
          icon: const Icon(
            Icons.dashboard,
            color: AppColor.gold,
          ),
          activeIcon: const Icon(
            Icons.dashboard,
          ),
          title: Text("bottomNav.statistic".tr)),
      BubbleBottomBarItem(
          backgroundColor: AppColor.gold,
          icon: const Icon(
            Icons.folder_open,
            color: AppColor.gold,
          ),
          activeIcon: const Icon(
            Icons.folder_open,
          ),
          title: Text("bottomNav.backup".tr)),
      BubbleBottomBarItem(
          backgroundColor: AppColor.gold,
          icon: const Icon(
            Icons.settings,
            color: AppColor.gold,
          ),
          activeIcon: const Icon(
            Icons.settings,
          ),
          title: Text("bottomNav.setting".tr)),
    ],
  );
}
