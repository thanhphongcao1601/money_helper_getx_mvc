import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

// ignore: must_be_immutable
class BackUpPage extends StatelessWidget {
  BackUpPage({super.key});
  AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.purple,
      child: Center(
          child: ElevatedButton(
        onPressed: () async {
          appController.handleBackUp();
        },
        child: Text('backUp'.tr),
      )),
    );
  }
}
