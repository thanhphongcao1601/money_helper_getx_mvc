import 'package:auto_size_text/auto_size_text.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_format_money_vietnam/flutter_format_money_vietnam.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import '../../ultis/widgets/record_tile.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildDashBoard(context),
        Expanded(
          child: listNote(context),
        )
      ],
    );
  }

  Widget buildDashBoard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black54),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => AutoSizeText(
                            homeController.totalIncome.value.toVND(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green),
                          ))
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Obx(() => AutoSizeText(
                            homeController.totalExpense.value.toVND(),
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ))
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white54,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Align(
                      alignment: Alignment.center,
                      child: Obx(() => Text(
                            (homeController.totalIncome.value +
                                    homeController.totalExpense.value)
                                .toString()
                                .toVND(),
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black),
                          ))),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget listNote(BuildContext context) {
    return Obx(() => ListView(
          children: [
            for (var item in homeController.listRecordGroupByDate.value.entries)
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    color: Theme.of(context).colorScheme.background,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          item.key,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        ),
                        Text(
                          item.value
                              .sumBy<int>((e) => e.money!)
                              .toString()
                              .toVND(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  for (var record in item.value) NoteTile(record: record),
                ],
              )
          ],
        ));
  }
}
