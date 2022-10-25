// ignore_for_file: unnecessary_string_escapes

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../home_module/model/record.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.find<HomeController>();

  late DateTime dateTime;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    dateTime = DateTime.now();
  }
  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
        child: Column(children: [
          buildHeader(context),
          buildDashboard(false),
          buildListRecord(context)
        ])));
  }

  Widget buildHeader(BuildContext context) {
    return SizedBox(
      // color: Theme.of(context).primaryColor,
      height: 80,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Hi',
                    style: TextStyle(fontSize: 20, color: AppColor.gold),
                  ),
                  Text('Phong Cao',
                      style: TextStyle(fontSize: 28, color: AppColor.gold)),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/dashboardbg.jpg'),
                radius: 30,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget buildDashboard(bool isExpense) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.gold, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 20, color: AppColor.darkPurple),
                ),
                Text(
                  (homeController.totalExpense.value +
                          homeController.totalIncome.value)
                      .toString(),
                  style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColor.darkPurple),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: Container(
                margin: const EdgeInsets.fromLTRB(10, 20, 5, 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.purple,
                    borderRadius: BorderRadius.circular(10)),
                height: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isExpense ? 'Expense' : 'Income',
                      style: const TextStyle(color: AppColor.gold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      isExpense
                          ? (homeController.totalExpense.value).toString()
                          : (homeController.totalIncome.value).toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.gold),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Container(
                margin: const EdgeInsets.fromLTRB(5, 20, 10, 20),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.purple,
                    borderRadius: BorderRadius.circular(10)),
                height: 60,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      !isExpense ? 'Expense' : 'Income',
                      style: const TextStyle(color: AppColor.gold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      !isExpense
                          ? (homeController.totalExpense.value).toString()
                          : (homeController.totalIncome.value).toString(),
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColor.gold),
                    )
                  ],
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget buildListRecord(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              for (var item
                  in homeController.listRecordGroupByDate.value.entries)
                Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          item.key,
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColor.gold,
                              fontWeight: FontWeight.bold),
                        ),
                        const Expanded(
                            child: Divider(
                          color: AppColor.gold,
                          thickness: 1,
                        ))
                      ],
                    ),
                    for (var record in item.value)
                      buildRecord(record: record, context: context)
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecord({required Record record, required BuildContext context}) {
    return Container(
      height: 50,
      margin: const EdgeInsets.fromLTRB(10, 5, 0, 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColor.darkPurple,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.all(5),
                  child: Text(
                    DateTime.fromMillisecondsSinceEpoch(record.datetime ?? 0)
                        .toString()
                        .substring(11, 19),
                    style: const TextStyle(color: Colors.white),
                  )),
              const Expanded(child: SizedBox()),
              Container(
                decoration: const BoxDecoration(
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(10)),
                  color: Colors.green,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    record.genre ?? "",
                    style: const TextStyle(
                        color: AppColor.darkPurple,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(record.content.toString(),
                    style: const TextStyle(color: Colors.white)),
                const Expanded(child: SizedBox()),
                Text(
                  record.money.toString(),
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.gold),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
