import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/models/record.dart';
import 'package:money_helper_getx_mvc/module/detail_record_module/detail_record_page.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/helper/helper.dart';

Widget buildRecordTile({required Record record}) {
  AppController appController = Get.find();
  return InkWell(
    onTap: () => Get.to(() => DetailRecordPage(
          currentRecord: record,
        )),
    child: Container(
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
                      DateTime.fromMillisecondsSinceEpoch(record.datetime ?? 0).toString().substring(11, 19),
                      style: const TextStyle(color: Colors.white),
                    )),
                Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                  child: Text(record.content.toString(), style: const TextStyle(color: Colors.white)),
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
                    borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(10)),
                    color: record.money! < 0
                        ? Helper().getItemTypeColor(record.genre!, appController.listGenre)
                        : Helper().getItemTypeColor(record.type!, appController.listType)),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    record.money! < 0 ? (record.genre ?? "").tr : (record.type ?? "").tr,
                    style: const TextStyle(color: AppColor.darkPurple, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Text(
                  Helper().formatMoney(record.money!),
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: record.money! > 0 ? AppColor.mustHave : AppColor.wasted),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}
