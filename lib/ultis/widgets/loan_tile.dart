import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/models/record.dart';
import 'package:money_helper_getx_mvc/module/detail_loan_module/detail_loan_page.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/helper/helper.dart';

Widget buildLoanTile({required Record record}) {
  return InkWell(
    onTap: () {
      Get.to(() => DetailLoanPage(currentLoan: record));
    },
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateTime.fromMillisecondsSinceEpoch(record.datetime!)
              .toString()
              .substring(0, 16),
          textAlign: TextAlign.start,
          style: const TextStyle(color: AppColor.gold, fontSize: 16),
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColor.darkPurple,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(5),
                        child: Text(
                          record.loanPersonName ?? '',
                          style: const TextStyle(
                              color: AppColor.gold,
                              fontWeight: FontWeight.bold),
                        )),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                      child: Text(record.loanContent.toString(),
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10)),
                        color: record.loanType == 'lend'
                            ? AppColor.blue
                            : Colors.red),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Text(
                        record.loanType!.tr,
                        style: const TextStyle(
                            color: AppColor.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: Text(
                      Helper().formatMoney(record.money!),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.gold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
