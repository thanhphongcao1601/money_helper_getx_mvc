import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/home_module/home_controller.dart';
import 'package:money_helper_getx_mvc/module/statistic_module/statistic_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/helper/helper.dart';
import 'package:money_helper_getx_mvc/ultis/widgets/record_tile.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.put(HomeController());
  final appController = Get.put(AppController());
  final statisticController = Get.put(StatisticController());

  @override
  void initState() {
    super.initState();
    homeController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            children: [buildHeader(), buildDashboard(), buildListRecord()])));
  }

  Widget buildHeader() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
        child: Obx(
          () => !appController.isLogged.value
              ? Align(
                  alignment: Alignment.centerRight,
                  child: buildButtonMonthYearPicker(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: appController.userPhotoUrl.value,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: imageProvider, fit: BoxFit.cover),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${'welcomeBack'.tr},',
                            style: const TextStyle(
                                fontSize: 16, color: AppColor.gold),
                          ),
                          Text(
                              appController.userDisplayName.value.split(' ')[0],
                              style: const TextStyle(
                                  fontSize: 24, color: AppColor.gold)),
                        ],
                      ),
                    ),
                    buildButtonMonthYearPicker()
                  ],
                ),
        ));
  }

  Widget buildButtonMonthYearPicker() {
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
          return null;
        },
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
                Expanded(
                  child: Obx(() => AutoSizeText(
                        Helper().formatMoney(
                            homeController.totalMonthExpense.value +
                                homeController.totalMonthIncome.value),
                        maxLines: 1,
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      )),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                  child: InkWell(
                onTap: () {
                  statisticController.currentTab.value = 0;
                  appController.changePage(1);
                },
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
                      AutoSizeText(
                        Helper().formatMoney(
                            homeController.totalMonthExpense.value),
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.wasted),
                      )
                    ],
                  ),
                ),
              )),
              Expanded(
                  child: InkWell(
                onTap: () {
                  statisticController.currentTab.value = 1;
                  appController.changePage(1);
                },
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
                      AutoSizeText(
                        Helper()
                            .formatMoney(homeController.totalMonthIncome.value),
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColor.mustHave),
                      )
                    ],
                  ),
                ),
              )),
            ],
          )
        ],
      ),
    );
  }

  Widget buildListRecord() {
    if (homeController.listRecordGroupByDate.value.isEmpty) {
      return Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/lotties/empty.json', width: 100),
          Text(
            'noData'.tr,
            style: const TextStyle(color: AppColor.gold),
          )
        ],
      ));
    }
    return Expanded(
      child: SizedBox(
        width: Get.width,
        child: SingleChildScrollView(
            child: Obx(() => Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    for (var item in homeController.listRecordGroupByDate.value)
                      Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                item.date,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.gold,
                                    fontWeight: FontWeight.bold),
                              ),
                              const Expanded(
                                  child: Divider(
                                color: AppColor.gold,
                                thickness: 1,
                              )),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                Helper().formatMoney(item.listRecord
                                    .sumBy<int>((e) => e.money!)),
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: AppColor.gold,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          for (var record in item.listRecord)
                            buildRecordTile(record: record)
                        ],
                      ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ))),
      ),
    );
  }
}
