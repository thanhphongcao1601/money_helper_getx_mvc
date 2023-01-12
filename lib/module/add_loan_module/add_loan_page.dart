import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/models/record.dart';
import 'package:money_helper_getx_mvc/models/record_history.dart';
import 'package:money_helper_getx_mvc/module/loan_module/loan_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class AddLoanPage extends StatefulWidget {
  const AddLoanPage({Key? key}) : super(key: key);

  @override
  State<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends State<AddLoanPage> with TickerProviderStateMixin {
  AppController appController = Get.put(AppController());
  LoanController loanController = Get.put(LoanController());

  late bool isBorrow;

  late TextEditingController datetimeC;
  late TextEditingController personNameC;
  late TextEditingController contentC;
  late TextEditingController moneyC;

  late DateTime dateTime;
  late String errorMessage;

  @override
  void initState() {
    super.initState();
    isBorrow = true;
    errorMessage = '';

    datetimeC = TextEditingController();
    personNameC = TextEditingController();
    contentC = TextEditingController();
    moneyC = TextEditingController();

    dateTime = DateTime.now();
    datetimeC.text = dateTime.millisecondsSinceEpoch.toString();
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
                  children: [buildDateTimeField(), buildMoneyField(), buildPersonNameField(), buildContentField()],
                ),
              ),
              buildErrorMessage(),
              buildSaveButton(),
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
      initialLabelIndex: isBorrow ? 0 : 1,
      cornerRadius: 20.0,
      activeFgColor: AppColor.darkPurple,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: ['loan.borrow'.tr, 'loan.lend'.tr],
      // icons: const [FontAwesomeIcons.minus, FontAwesomeIcons.plus],
      activeBgColors: const [
        [AppColor.gold],
        [AppColor.gold],
      ],
      onToggle: (index) {
        setState(() {
          isBorrow = (index == 0);
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
                initialValue: dateTime,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'form.dateAndTimeHint'.tr, hintStyle: const TextStyle(color: Colors.grey)),
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
                controller: moneyC,
                style: const TextStyle(color: Colors.black),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'form.moneyHint'.tr,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            )),
      ],
    );
  }

  Widget buildPersonNameField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'form.personName'.tr,
          style: const TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: personNameC,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'form.personNameHint'.tr,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey)),
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
                controller: contentC,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'form.contentHint'.tr,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey)),
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
          handleAddRecord();
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
        child: Text(
          'form.button.save'.tr,
          style: const TextStyle(color: AppColor.darkPurple),
        ),
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

  Future<void> handleAddRecord() async {
    setState(() {
      errorMessage = '';
    });

    if (datetimeC.text.isEmpty) {
      errorMessage += '${'form.dateAndTime.validate'.tr}\n';
    }
    if (personNameC.text.isEmpty) {
      errorMessage += '${'form.personName.validate'.tr}\n';
    }
    if (moneyC.text.isEmpty) {
      errorMessage += '${'form.money.validate'.tr}\n';
    }

    if (errorMessage != '') {
      setState(() {
        errorMessage;
      });
    }

    if (errorMessage == '') {
      Record record = Record(
          id: const Uuid().v4(),
          isLoan: true,
          datetime: dateTime.millisecondsSinceEpoch,
          loanType: isBorrow ? 'borrow' : 'lend',
          loanContent: contentC.text,
          loanPersonName: personNameC.text,
          money: int.parse(moneyC.text.replaceAll(',', '')),
          recordHistoryList: []);

      debugPrint(jsonEncode(record.toJson()));

      appController.addRecord(record);
      loanController.loadAllData();

      Get.back(closeOverlays: true);
      Get.snackbar(
          duration: const Duration(seconds: 1),
          "snackbar.add.success.title".tr,
          "snackbar.add.success.message".tr,
          colorText: AppColor.darkPurple,
          backgroundColor: AppColor.gold);
    }
  }
}
