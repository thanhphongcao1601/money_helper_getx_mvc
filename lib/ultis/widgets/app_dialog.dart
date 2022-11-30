import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

showAppDialog({required String title, required Widget content, Function? confirm}) {
  Get.defaultDialog(
    backgroundColor: AppColor.purple,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    title: title,
    titleStyle: const TextStyle(color: AppColor.gold),
    content: content,
    confirm: confirm!=null ? ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
        onPressed: () {
          Get.back();
          confirm();
        },
        child: Text(
          "form.button.save".tr,
          style: const TextStyle(color: AppColor.darkPurple),
        )): null,
    cancel: confirm!=null? Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColor.gold),
          ),
          onPressed: () {
            Get.back();
          },
          child: Text(
            "form.button.cancel".tr,
            style: const TextStyle(color: AppColor.gold),
          )),
    ):null,
  );
}
