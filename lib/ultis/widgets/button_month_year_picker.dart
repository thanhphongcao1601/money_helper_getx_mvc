import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_helper_getx_mvc/module/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

Widget buildButtonMonthYearPicker() {
  final homeController = Get.find<HomeController>();
  return SizedBox(
    width: 100,
    child: DateTimeField(
      textAlign: TextAlign.center,
      resetIcon: null,
      style: const TextStyle(color: AppColor.gold),
      initialValue: DateTime.now(),
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(10),
        isCollapsed: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide:
              const BorderSide(width: 2, color: AppColor.gold), //<-- SEE HERE
        ),
      ),
      format: DateFormat("MM/yyyy"),
      onShowPicker: (context, currentValue) async {
        final date = await showMonthPicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (date != null) {
          homeController.handleHomeChangeMonthYear(date);
          return date;
        }
      },
    ),
  );
}
