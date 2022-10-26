import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

class BackUpPage extends StatelessWidget {
  BackUpPage({super.key});
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.purple,
    );
  }
}
