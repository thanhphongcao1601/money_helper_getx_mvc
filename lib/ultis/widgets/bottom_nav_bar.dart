import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';

Widget buildBottomBar(
    int currentIndex, BuildContext context) {
  AppController appController = Get.find<AppController>();
  return BubbleBottomBar(
    backgroundColor: Theme.of(context).primaryColor,
    opacity: .2,
    currentIndex: currentIndex,
    onTap: appController.changePage,
    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
    elevation: 8,
    fabLocation: BubbleBottomBarFabLocation.end,
    hasNotch: true,
    hasInk: true,
    inkColor: Colors.black12,
    items: <BubbleBottomBarItem>[
      BubbleBottomBarItem(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          icon: const Icon(
            Icons.access_time,
          ),
          activeIcon: const Icon(
            Icons.access_time,
          ),
          title: const Text("Nhật ký")),
      BubbleBottomBarItem(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          icon: const Icon(
            Icons.dashboard,
          ),
          activeIcon: const Icon(
            Icons.dashboard,
          ),
          title: const Text("Thống kê")),
      BubbleBottomBarItem(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          icon: const Icon(
            Icons.folder_open,
          ),
          activeIcon: const Icon(
            Icons.folder_open,
          ),
          title: const Text("Sao lưu")),
      BubbleBottomBarItem(
          backgroundColor: Theme.of(context).colorScheme.onSurface,
          icon: const Icon(
            Icons.settings,
          ),
          activeIcon: const Icon(
            Icons.settings,
          ),
          title: const Text("Cài đặt"))
    ],
  );
}
