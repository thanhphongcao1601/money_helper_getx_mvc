import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/add_loan_module/add_loan_page.dart';
import 'package:money_helper_getx_mvc/module/loan_module/loan_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/widgets/loan_tile.dart';

class LoanPage extends StatefulWidget {
  const LoanPage({super.key});

  @override
  State<LoanPage> createState() => _LoanPageState();
}

class _LoanPageState extends State<LoanPage> {
  AppController appController = Get.find();

  LoanController loanController = Get.put(LoanController());
  @override
  void initState() {
    super.initState();
    loanController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: AppColor.purple,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'loan.lend'.tr} : ',
                style: const TextStyle(color: AppColor.gold, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                    loanController.totalLend.value.toString(),
                    style: const TextStyle(color: AppColor.blue, fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${'loan.borrow'.tr} : ',
                style: const TextStyle(color: AppColor.gold, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Obx(() => Text(
                    loanController.totalBorrow.value.toString(),
                    style: const TextStyle(color: AppColor.wasted, fontSize: 18, fontWeight: FontWeight.bold),
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Obx(() =>
                Column(children: [for (var record in loanController.listLoan.value) buildLoanTile(record: record)])),
          )),
        ],
      ),
    );
  }
}
