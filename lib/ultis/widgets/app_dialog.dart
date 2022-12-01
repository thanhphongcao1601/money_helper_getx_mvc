import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

showAppDialog(
    {required String title,
    required Widget content,
    Function? onConfirm,
    Function? onCancel,
    String? confirmText,
    String? cancelText}) {
  Get.defaultDialog(
    backgroundColor: AppColor.purple,
    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    title: title,
    titleStyle: const TextStyle(color: AppColor.gold),
    content: content,
    confirm: onConfirm != null
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              confirmText ?? "form.button.save".tr,
              style: const TextStyle(color: AppColor.darkPurple),
            ))
        : null,
    cancel: onConfirm != null
        ? Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColor.gold),
                ),
                onPressed: () {
                  Get.back();
                  if (onCancel != null) {
                    onCancel();
                  }
                },
                child: Text(
                  cancelText ?? "form.button.cancel".tr,
                  style: const TextStyle(color: AppColor.gold),
                )),
          )
        : null,
  );
}
