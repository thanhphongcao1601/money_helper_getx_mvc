import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_helper_getx_mvc/api/google_sign_in.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/detail_record_module/view/detail_record_page.dart';
import 'package:money_helper_getx_mvc/module/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/helper/helper.dart';
import 'package:month_picker_dialog_2/month_picker_dialog_2.dart';
import '../../home_module/model/record.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final homeController = Get.put(HomeController());
  final appController = Get.put(AppController());

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
          () => appController.userId.value == ''
              ? Align(
                  alignment: Alignment.centerRight,
                  child: buildButtonMonthYearPicker(),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        GApi().handleSignIn();
                      },
                      child: CircleAvatar(
                        backgroundImage: NetworkImage(appController
                                .userPhotoUrl.value.isNotEmpty
                            ? appController.userPhotoUrl.value
                            : 'https://daknong.dms.gov.vn/CmsView-QLTT-portlet/res/no-image.jpg'),
                        radius: 25,
                      ),
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
                Obx(() => Text(
                      Helper().formatMoney(
                          homeController.totalMonthExpense.value +
                              homeController.totalMonthIncome.value),
                      style: const TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: AppColor.darkPurple),
                    )),
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
                      Helper()
                          .formatMoney(homeController.totalMonthIncome.value),
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
                      Helper()
                          .formatMoney(homeController.totalMonthExpense.value),
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
    if (homeController.listRecordGroupByDate.value.isEmpty) {
      return Expanded(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/lotties/empty.json', width: 100),
          Text(
            'noData'.tr,
            style: TextStyle(color: AppColor.gold),
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
                              ))
                            ],
                          ),
                          for (var record in item.listRecord)
                            buildRecord(record: record, context: context)
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
                    Helper().formatMoney(record.money!),
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
