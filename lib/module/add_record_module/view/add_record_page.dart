import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';
import 'package:money_helper_getx_mvc/module/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/module/home_module/model/record.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage>
    with TickerProviderStateMixin {
  AppController appController = Get.find();
  HomeController homeController = Get.find();

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

  @override
  void initState() {
    super.initState();
    isExpense = true;
    currentItemGenre = '';
    errorMessage = '';

    datetimeC = TextEditingController();
    genreC = TextEditingController();
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
                  children: [
                    buildDateTimeField(),
                    buildGenreField(),
                    buildMoneyField(),
                    buildContentField()
                  ],
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
      initialLabelIndex: isExpense ? 0 : 1,
      cornerRadius: 20.0,
      activeFgColor: AppColor.darkPurple,
      inactiveBgColor: Colors.grey,
      inactiveFgColor: Colors.white,
      totalSwitches: 2,
      labels: const ['Expense', 'Income'],
      icons: const [FontAwesomeIcons.minus, FontAwesomeIcons.plus],
      activeBgColors: const [
        [AppColor.gold],
        [AppColor.gold],
      ],
      onToggle: (index) {
        setState(() {
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DateTimeField(
                initialValue: dateTime,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'form.dateAndTimeHint'.tr,
                    hintStyle: const TextStyle(color: Colors.grey)),
                format: DateFormat("yyyy-MM-dd  HH:mm"),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(2000),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: DateTime(2100));
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
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
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: TextField(
                  controller: genreC,
                  style: const TextStyle(color: Colors.black),
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: 'form.typeHint'.tr,
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.grey)),
                ),
              )),
          GridView.count(
            padding: const EdgeInsets.all(5),
            crossAxisCount: 3,
            shrinkWrap: true,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 3 / 1,
            children: [
              for (var item in AppConstantList.listIncomeType)
                buildItemGenre(item, currentItemGenre == item)
            ],
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: genreC,
                style: const TextStyle(color: Colors.black),
                readOnly: true,
                decoration: InputDecoration(
                    hintText: 'form.typeHint'.tr,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            )),
        GridView.count(
          padding: const EdgeInsets.all(5),
          crossAxisCount: 3,
          shrinkWrap: true,
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          childAspectRatio: 3 / 1,
          children: [
            for (var item in AppConstantList.listExpenseGenre)
              buildItemGenre(item, currentItemGenre == item)
          ],
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: moneyC,
                style: const TextStyle(color: Colors.black),
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: InputDecoration(
                    hintText: 'form.moneyHint'.tr,
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
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
          Get.back();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.gold),
        ),
        child: Text('form.button.cancel'.tr,
            style: const TextStyle(color: AppColor.gold)),
      ),
    );
  }

  Widget buildItemGenre(String item, bool isSelected) {
    return InkWell(
      onTap: () => chooseItem(item),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected ? AppColor.gold : Colors.grey,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          item.tr,
          style:
              TextStyle(color: isSelected ? AppColor.darkPurple : Colors.white),
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

  Future<void> handleAddRecord() async {
    setState(() {
      errorMessage = '';
    });

    if (datetimeC.text.isEmpty) {
      errorMessage += 'Date & Time can not null\n';
    }
    if (genreC.text.isEmpty) {
      errorMessage += 'Type can not null\n';
    }
    if (moneyC.text.isEmpty) {
      errorMessage += 'Money can not null\n';
    }
    if (contentC.text.isEmpty) {
      errorMessage += 'Content can not null\n';
    }

    if (errorMessage != '') {
      setState(() {
        errorMessage;
      });
    }

    if (errorMessage == '') {
      Record recordExpense = Record(
          id: const Uuid().v4(),
          datetime: dateTime.millisecondsSinceEpoch,
          genre: isExpense ? currentItemGenre : null,
          type: !isExpense ? currentItemGenre : null,
          content: contentC.text,
          money: isExpense ? -int.parse(moneyC.text) : int.parse(moneyC.text));

      appController.addRecord(recordExpense);
      homeController.loadAllData();

      Get.back();
      Get.snackbar(
          "snackbar.add.success.title".tr, "snackbar.add.success.message".tr,
          colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
    }
  }
}
