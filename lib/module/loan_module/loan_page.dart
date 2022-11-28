import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

// ignore: must_be_immutable
class LoanPage extends StatelessWidget {
  LoanPage({super.key});
  AppController appController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColor.purple,
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'loan.loan'.tr,
                style: const TextStyle(color: AppColor.gold, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Text(
                'loan.inDebt'.tr,
                style: const TextStyle(color: AppColor.gold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
