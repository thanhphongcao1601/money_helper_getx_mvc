import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/detail_record_module/view/detail_record_page.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import '../../home_module/model/record.dart';
import '../../ultis/helper/helper.dart';

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
    super.initState();
    dateTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            children: [
              buildHeader(), 
              buildDashboard(), 
              buildListRecord()
            ])));
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
                    'Hi,',
                    style: TextStyle(fontSize: 20, color: AppColor.gold),
                  ),
                  Text('Human',
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

  Widget buildDashboard() {
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
                Text(
                  '${'total'.tr}:',
                  style:
                      const TextStyle(fontSize: 20, color: AppColor.darkPurple),
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
                      'income'.tr,
                      style: const TextStyle(color: AppColor.gold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (homeController.totalIncome.value).toString(),
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
                      'expense'.tr,
                      style: const TextStyle(color: AppColor.gold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      (homeController.totalExpense.value).toString(),
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

  Widget buildListRecord() {
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
                ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRecord({required Record record, required BuildContext context}) {
    return InkWell(
      onTap: () => Get.to(DetailRecordPage(
        currentRecord: record,
      )),
      child: Container(
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
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10)),
                      color: Helper().getItemTypeColor(
                          record.money! < 0 ? record.genre! : record.type!)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      record.money! < 0
                          ? (record.genre ?? "").tr
                          : (record.type ?? "").tr,
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
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: record.money! > 0
                            ? AppColor.mustHave
                            : AppColor.wasted),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
