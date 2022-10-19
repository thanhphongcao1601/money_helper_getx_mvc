import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';

import '../constants/constant.dart';

Widget buildBottomBar(
    int currentIndex) {
  HomeController homeController = Get.find<HomeController>();
  return BubbleBottomBar(
    opacity: .2,
    currentIndex: currentIndex,
    onTap: homeController.changePage,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    elevation: 8,
    fabLocation: BubbleBottomBarFabLocation.end,
    //new
    hasNotch: true,
    //new
    hasInk: true,
    //new, gives a cute ink effect
    inkColor: Colors.black12,
    //optional, uses theme color if not specified
    items: const <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: Color(AppColor.yellow),
          icon: Icon(
            Icons.access_time,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.access_time,
            color: Color(AppColor.yellow),
          ),
          title: Text("Nhật ký")),
      BubbleBottomBarItem(
          backgroundColor: Color(AppColor.yellow),
          icon: Icon(
            Icons.dashboard,
            color: Colors.black,
          ),
          activeIcon: Icon(
            Icons.dashboard,
            color: Color(AppColor.yellow),
          ),
          title: Text("Thống kê")),
      // BubbleBottomBarItem(
      //     backgroundColor: Color(AppColor.yellow),
      //     icon: Icon(
      //       Icons.folder_open,
      //       color: Colors.black,
      //     ),
      //     activeIcon: Icon(
      //       Icons.folder_open,
      //       color: Color(AppColor.yellow),
      //     ),
      //     title: Text("Sao lưu")),
      // BubbleBottomBarItem(
      //     backgroundColor: Color(AppColor.yellow),
      //     icon: Icon(
      //       Icons.settings,
      //       color: Colors.black,
      //     ),
      //     activeIcon: Icon(
      //       Icons.settings,
      //       color: Color(AppColor.yellow),
      //     ),
      //     title: Text("Cài đặt"))
    ],
  );
}
