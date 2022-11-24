import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/home_module/home_controller.dart';
import 'package:money_helper_getx_mvc/module/statistic_module/statistic_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:pattern_formatter/pattern_formatter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import '../../models/record.dart';

class DetailRecordPage extends StatefulWidget {
  const DetailRecordPage({Key? key, required this.currentRecord}) : super(key: key);
  final Record currentRecord;

  @override
  State<DetailRecordPage> createState() => _DetailRecordPageState();
}

class _DetailRecordPageState extends State<DetailRecordPage> with TickerProviderStateMixin {
  AppController appController = Get.put(AppController());
  HomeController homeController = Get.put(HomeController());
  StatisticController statisticController = Get.put(StatisticController());

  final formKeyExpense = GlobalKey<FormState>();
  final formKeyIncome = GlobalKey<FormState>();

  late bool isExpense;
  late String currentItemGenre;

  late TextEditingController datetimeC;
  late TextEditingController expenseTypeC;
  late TextEditingController genreC;
  late TextEditingController contentC;
  late TextEditingController moneyC;

  late DateTime dateTime;
  late String errorMessage;
  late Record currentRecord;

  @override
  void initState() {
    super.initState();
    datetimeC = TextEditingController();
    genreC = TextEditingController();
    contentC = TextEditingController();
    moneyC = TextEditingController();

    currentRecord = widget.currentRecord;
    isExpense = currentRecord.money! < 0;

    dateTime = DateTime.fromMillisecondsSinceEpoch(currentRecord.datetime!);
    datetimeC.text = dateTime.millisecondsSinceEpoch.toString();
    currentItemGenre = currentRecord.money! < 0 ? currentRecord.genre.toString() : currentRecord.type.toString();
    genreC.text = currentItemGenre.tr;
    errorMessage = '';
    moneyC.text = currentRecord.money!.abs().toString();
    contentC.text = currentRecord.content.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        color: AppColor.purple,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              buildToggleButton(),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [buildDateTimeField(), buildGenreField(), buildMoneyField(), buildContentField()],
                ),
              ),
              buildErrorMessage(),
              buildSaveButton(),
              buildDeleteButton(),
              buildCancelButton()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildToggleButton() {
    return ToggleSwitch(
      minWidth: Get.width,
      initialLabelIndex: isExpense ? 0 : 1,
      cornerRadius: 20.0,
      activeFgColor: AppColor.darkPurple,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: ['tab.expense'.tr, 'tab.income'.tr],
      icons: const [FontAwesomeIcons.minus, FontAwesomeIcons.plus],
      activeBgColors: const [
        [AppColor.gold],
        [AppColor.gold],
      ],
      onToggle: (index) {
        setState(() {
          genreC.text = '';
          isExpense = (index == 0);
        });
      },
    );
  }

  Widget buildDateTimeField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'form.dateAndTime'.tr,
          style: const TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DateTimeField(
                resetIcon: null,
                style: const TextStyle(color: Colors.black),
                initialValue: dateTime,
                decoration: InputDecoration(hintText: 'form.dateAndTimeHint'.tr, hintStyle: const TextStyle(color: Colors.grey)),
                format: DateFormat("yyyy-MM-dd  HH:mm"),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      builder: (context, child) => Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primaryContainer: AppColor.purple,
                                primary: AppColor.darkPurple, // header background color
                                onPrimary: AppColor.gold, // header text color
                                onSurface: AppColor.darkPurple, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  foregroundColor: AppColor.darkPurple, // button text color
                                ),
                              ),
                            ),
                            child: child!,
                          ),
                      context: context,
                      firstDate: DateTime(2000),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      builder: (context, child) => Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primaryContainer: AppColor.purple,
                            primary: AppColor.darkPurple, // header background color
                            onPrimary: AppColor.gold, // header text color
                            onSurface: AppColor.darkPurple, // body text color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: AppColor.darkPurple, // button text color
                            ),
                          ),
                        ),
                        child: child!,
                      ),
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                    );
                    dateTime = DateTimeField.combine(date, time);
                    return dateTime;
                  } else {
                    return currentValue;
                  }
                },
              ),
            )),
      ],
    );
  }

  Widget buildGenreField() {
    if (!isExpense) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'form.type'.tr,
            style: const TextStyle(color: AppColor.gold),
          ),
          Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: genreC,
                  readOnly: true,
                  decoration: InputDecoration(hintText: 'form.typeHint'.tr, border: InputBorder.none, hintStyle: const TextStyle(color: Colors.grey)),
                ),
              )),
          GridView.count(
            padding: const EdgeInsets.all(5),
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 3 / 1,
            children: [for (var item in AppConstantList.listIncomeType) buildItemGenre(item, currentItemGenre == item)],
          ),
        ],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'form.type'.tr,
          style: const TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: genreC,
                readOnly: true,
                decoration: InputDecoration(hintText: 'form.typeHint'.tr, border: InputBorder.none, hintStyle: const TextStyle(color: Colors.grey)),
              ),
            )),
        GridView.count(
          padding: const EdgeInsets.all(5),
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 3 / 1,
          children: [for (var item in AppConstantList.listExpenseGenre) buildItemGenre(item, currentItemGenre == item)],
        ),
      ],
    );
  }

  Widget buildMoneyField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'form.money'.tr,
          style: const TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                inputFormatters: [ThousandsFormatter()],
                style: const TextStyle(color: Colors.black),
                controller: moneyC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(hintText: 'form.moneyHint'.tr, border: InputBorder.none, hintStyle: const TextStyle(color: Colors.grey)),
              ),
            )),
      ],
    );
  }

  Widget buildContentField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'form.content'.tr,
          style: const TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                style: const TextStyle(color: Colors.black),
                controller: contentC,
                decoration:
                    InputDecoration(hintText: 'form.contentHint'.tr, border: InputBorder.none, hintStyle: const TextStyle(color: Colors.grey)),
              ),
            )),
      ],
    );
  }

  Widget buildErrorMessage() {
    if (errorMessage != '') {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }
    return const SizedBox();
  }

  Widget buildSaveButton() {
    return SizedBox(
      width: Get.width / 2,
      child: ElevatedButton(
        onPressed: () {
          handleUpdateRecord();
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
        child: Text(
          'form.button.save'.tr,
          style: const TextStyle(color: AppColor.darkPurple),
        ),
      ),
    );
  }

  Widget buildDeleteButton() {
    return SizedBox(
      width: Get.width / 2,
      child: OutlinedButton(
        onPressed: () {
          handleDeleteRecord();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
        ),
        child: Text('form.button.delete'.tr, style: const TextStyle(color: Colors.red)),
      ),
    );
  }

  Widget buildCancelButton() {
    return SizedBox(
      width: Get.width / 2,
      child: OutlinedButton(
        onPressed: () {
          Get.back(closeOverlays: true);
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.gold),
        ),
        child: Text('form.button.cancel'.tr, style: const TextStyle(color: AppColor.gold)),
      ),
    );
  }

  Widget buildItemGenre(String item, bool isSelected) {
    return InkWell(
      onTap: () => chooseItem(item),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: isSelected ? AppColor.gold : Colors.grey, borderRadius: BorderRadius.circular(10)),
        child: Text(
          item.tr,
          style: TextStyle(color: isSelected ? AppColor.darkPurple : Colors.white),
        ),
      ),
    );
  }

  void chooseItem(String item) {
    setState(() {
      currentItemGenre = item;
      genreC.text = item.tr;
    });
  }

  void handleDeleteRecord() {
    Get.defaultDialog(
      backgroundColor: AppColor.purple,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: Text(
        "form.dialog.delete.content".tr,
        style: const TextStyle(color: Colors.white),
      ),
      title: "form.dialog.delete.title".tr,
      titleStyle: const TextStyle(color: AppColor.gold),
      confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
          onPressed: () {
            appController.deleteRecord(currentRecord);
            homeController.loadAllData();
            statisticController.loadAllData();

            Get.back(closeOverlays: true);
            Get.snackbar(
                "snackbar.delete.success.title".tr,
                duration: const Duration(seconds: 1),
                "snackbar.delete.success.message".tr,
                colorText: AppColor.darkPurple,
                backgroundColor: AppColor.gold);
          },
          child: Text(
            "form.button.delete".tr,
            style: const TextStyle(color: AppColor.darkPurple),
          )),
      cancel: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColor.gold),
            ),
            onPressed: () {
              Get.back(closeOverlays: true);
            },
            child: Text(
              "form.button.cancel".tr,
              style: const TextStyle(color: AppColor.gold),
            )),
      ),
    );
  }

  void handleUpdateRecord() {
    setState(() {
      errorMessage = '';
    });

    if (datetimeC.text.isEmpty) {
      errorMessage += '${'form.dateAndTime.validate'.tr}\n';
    }
    if (genreC.text.isEmpty) {
      errorMessage += '${'form.type.validate'.tr}\n';
    }
    if (moneyC.text.isEmpty) {
      errorMessage += '${'form.money.validate'.tr}\n';
    }
    if (contentC.text.isEmpty) {
      errorMessage += '${'form.content.validate'.tr}\n';
    }

    if (errorMessage != '') {
      setState(() {
        errorMessage;
      });
    } else {
      final recordExpense = Record(
          id: currentRecord.id,
          datetime: dateTime.millisecondsSinceEpoch,
          genre: isExpense ? currentItemGenre : null,
          type: !isExpense ? currentItemGenre : null,
          content: contentC.text,
          money: isExpense ? -int.parse(moneyC.text.replaceAll(',', '')) : int.parse(moneyC.text.replaceAll(',', '')));

      appController.updateRecord(recordExpense);
      homeController.loadAllData();
      statisticController.loadAllData();

      Get.back(closeOverlays: true);
      Get.snackbar("snackbar.update.success.title".tr, "snackbar.update.success.message".tr,
          duration: const Duration(seconds: 1), colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
    }
  }
}
