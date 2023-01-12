import 'dart:convert';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/models/record.dart';
import 'package:money_helper_getx_mvc/models/record_history.dart';
import 'package:money_helper_getx_mvc/module/loan_module/loan_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/widgets/app_dialog.dart';
import 'package:money_helper_getx_mvc/ultis/widgets/loan_history_tile.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class DetailLoanPage extends StatefulWidget {
  const DetailLoanPage({Key? key, required this.currentLoan}) : super(key: key);
  final Record currentLoan;

  @override
  State<DetailLoanPage> createState() => _DetailLoanPageState();
}

class _DetailLoanPageState extends State<DetailLoanPage> with TickerProviderStateMixin {
  AppController appController = Get.put(AppController());
  LoanController loanController = Get.put(LoanController());

  late bool isBorrow;

  late TextEditingController datetimeC;
  late TextEditingController personNameC;
  late TextEditingController contentC;
  late TextEditingController moneyC;

  late DateTime dateTime;
  late String errorMessage;
  late Record currentLoan;

  late bool showHistory;

  @override
  void initState() {
    super.initState();
    showHistory = false;
    isBorrow = true;
    errorMessage = '';

    currentLoan = widget.currentLoan;
    isBorrow = currentLoan.loanType == 'borrow';

    datetimeC = TextEditingController();
    personNameC = TextEditingController();
    contentC = TextEditingController();
    moneyC = TextEditingController();

    personNameC.text = currentLoan.loanPersonName ?? '';
    contentC.text = currentLoan.loanContent ?? '';
    moneyC.text = currentLoan.money.toString();

    // dateTime = DateTime.fromMillisecondsSinceEpoch(currentLoan.datetime!);
    dateTime = DateTime.now();
    datetimeC.text = dateTime.millisecondsSinceEpoch.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: Get.height,
        width: Get.width,
        color: AppColor.purple,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              buildToggleButton(),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                  onTap: () {
                    setState(() {
                      showHistory = !showHistory;
                    });
                  },
                  child: Container(
                    width: Get.width / 2,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: AppColor.gold), borderRadius: BorderRadius.circular(50)),
                    padding: const EdgeInsets.all(5),
                    child: !showHistory
                        ? Text(
                            'loan.showHistory'.tr,
                            style: const TextStyle(color: AppColor.gold, fontSize: 16),
                          )
                        : Text(
                            'loan.goBack'.tr,
                            style: const TextStyle(color: AppColor.gold, fontSize: 16),
                          ),
                  )),
              !showHistory
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildDateTimeField(),
                              buildMoneyField(),
                              buildPersonNameField(),
                              buildContentField()
                            ],
                          ),
                        ),
                        buildErrorMessage(),
                        buildSaveButton(),
                        buildDeleteButton(),
                        buildCancelButton(),
                      ],
                    )
                  : buildHistory()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHistory() {
    List<RecordHistory> listHistory = currentLoan.recordHistoryList ?? [];
    if (listHistory.isEmpty) {
      return Column(
        children: [
          const SizedBox(
            height: 30,
          ),
          Lottie.asset('assets/lotties/empty.json', width: 100),
        ],
      );
    }
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          for (var history in listHistory) buildLoanHistoryTile(record: history)
        ],
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

  void handleUpdateRecord() {
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

    if (errorMessage != '') {
      setState(() {
        errorMessage;
      });
    } else {
      RecordHistory oldLoan = RecordHistory(
        id: currentLoan.id,
        isLoan: true,
        datetime: currentLoan.datetime,
        loanType: currentLoan.loanType,
        loanContent: currentLoan.loanContent,
        loanPersonName: currentLoan.loanPersonName,
        money: currentLoan.money,
      );

      List<RecordHistory> listRecordHistory = currentLoan.recordHistoryList ?? [];
      listRecordHistory.insert(0, oldLoan);

      Record record = Record(
          id: currentLoan.id,
          isLoan: true,
          datetime: dateTime.millisecondsSinceEpoch,
          loanType: isBorrow ? 'borrow' : 'lend',
          loanContent: contentC.text,
          loanPersonName: personNameC.text,
          money: int.parse(moneyC.text.replaceAll(',', '')),
          recordHistoryList: listRecordHistory);

      debugPrint(jsonEncode(record.toJson()));

      appController.updateRecord(record);
      loanController.loadAllData();

      Get.back(closeOverlays: true);
      Get.snackbar("snackbar.update.success.title".tr, "snackbar.update.success.message".tr,
          duration: const Duration(seconds: 1), colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
    }
  }

  void handleDeleteRecord() {
    Widget content = Text(
      "form.dialog.delete.content".tr,
      style: const TextStyle(color: Colors.white),
    );

    showAppDialog(
        title: "form.dialog.delete.title".tr,
        content: content,
        onConfirm: deleteRecord,
        confirmText: 'form.button.delete'.tr);
  }

  deleteRecord() {
    appController.deleteRecord(currentLoan);
    loanController.loadAllData();

    Get.back(closeOverlays: true);
    Get.snackbar(
        "snackbar.delete.success.title".tr,
        duration: const Duration(seconds: 1),
        "snackbar.delete.success.message".tr,
        colorText: AppColor.darkPurple,
        backgroundColor: AppColor.gold);
  }
}
