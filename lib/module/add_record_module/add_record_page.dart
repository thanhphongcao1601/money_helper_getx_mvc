import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/home_module/home_controller.dart';
import 'package:money_helper_getx_mvc/models/record.dart';
import 'package:money_helper_getx_mvc/module/statistic_module/statistic_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/ultis/widgets/app_dialog.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';
import 'package:pattern_formatter/pattern_formatter.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage> with TickerProviderStateMixin {
  AppController appController = Get.put(AppController());
  HomeController homeController = Get.put(HomeController());
  StatisticController statisticController = Get.put(StatisticController());

  final formKeyExpense = GlobalKey<FormState>();
  final formKeyIncome = GlobalKey<FormState>();

  late bool isExpense;
  late String currentItemSelected;

  late TextEditingController datetimeC;
  late TextEditingController expenseTypeC;
  late TextEditingController genreC;
  late TextEditingController contentC;
  late TextEditingController moneyC;
  late TextEditingController addNewItemSelectedC;

  late DateTime dateTime;
  late String errorMessage;

  @override
  void initState() {
    super.initState();
    isExpense = true;
    currentItemSelected = '';
    errorMessage = '';

    datetimeC = TextEditingController();
    genreC = TextEditingController();
    contentC = TextEditingController();
    moneyC = TextEditingController();
    addNewItemSelectedC = TextEditingController();

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
                  children: [buildDateTimeField(), buildGenreOrTypeField(), buildMoneyField(), buildContentField()],
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
      labels: ['tab.expense'.tr, 'tab.income'.tr],
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

  Widget buildGenreOrTypeField() {
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
                  controller: genreC,
                  style: const TextStyle(color: Colors.black),
                  readOnly: true,
                  decoration: InputDecoration(
                      hintText: 'form.typeHint'.tr,
                      border: InputBorder.none,
                      hintStyle: const TextStyle(color: Colors.grey)),
                ),
              )),
          Obx(() => GridView.count(
                padding: const EdgeInsets.all(5),
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 3 / 1,
                children: [
                  for (var item in appController.listType) buildItemSelected(item, currentItemSelected == item),
                  buildAddItem()
                ],
              )),
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
                controller: genreC,
                style: const TextStyle(color: Colors.black),
                readOnly: true,
                decoration: InputDecoration(
                    hintText: 'form.typeHint'.tr,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            )),
        Obx(() => GridView.count(
              padding: const EdgeInsets.all(5),
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              childAspectRatio: 3 / 1,
              children: [
                for (var item in appController.listGenre) buildItemSelected(item, currentItemSelected == item),
                buildAddItem()
              ],
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

  Widget buildItemSelected(String item, bool isSelected) {
    return InkWell(
      onLongPress: () => showDialogConfirmDelete(item),
      onTap: () => chooseItem(item),
      child: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: isSelected ? AppColor.gold : Colors.grey, borderRadius: BorderRadius.circular(10)),
        child: Text(
          item.tr,
          style: TextStyle(color: isSelected ? AppColor.darkPurple : Colors.white),
        ),
      ),
    );
  }

  Widget buildAddItem() {
    return InkWell(
      onTap: () => showDialogAddNewItemSelected(),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(color: Colors.grey, borderRadius: BorderRadius.circular(10)),
        child: const Text(
          '+',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  void chooseItem(String item) {
    setState(() {
      currentItemSelected = item;
      genreC.text = item.tr;
    });
  }

  Future<void> handleAddRecord() async {
    setState(() {
      errorMessage = '';
    });

    if (datetimeC.text.isEmpty) {
      errorMessage += '${'form.dateAndTime.validate'.tr}\n';
    }
    if (genreC.text.isEmpty) {
      errorMessage += '${'form.genre.validate'.tr}\n';
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
    }

    if (errorMessage == '') {
      Record recordExpense = Record(
          id: const Uuid().v4(),
          datetime: dateTime.millisecondsSinceEpoch,
          genre: isExpense ? currentItemSelected : null,
          type: !isExpense ? currentItemSelected : null,
          content: contentC.text,
          money: isExpense ? -int.parse(moneyC.text.replaceAll(',', '')) : int.parse(moneyC.text.replaceAll(',', '')));

      appController.addRecord(recordExpense);
      homeController.loadAllData();
      statisticController.loadAllData();

      Get.back(closeOverlays: true);
      Get.snackbar(
          duration: const Duration(seconds: 1),
          "snackbar.add.success.title".tr,
          "snackbar.add.success.message".tr,
          colorText: AppColor.darkPurple,
          backgroundColor: AppColor.gold);
    }
  }

  showDialogAddNewItemSelected() {
    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: addNewItemSelectedC,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                    hintText: 'form.addNewItemSelectedHint'.tr,
                    border: InputBorder.none,
                    hintStyle: const TextStyle(color: Colors.grey)),
              ),
            )),
      ],
    );
    showAppDialog(
        title: "form.dialog.addNewItemSelected.title".tr,
        content: content,
        confirm: () {
          addNewItemSelected(isExpense, addNewItemSelectedC.text);
        });
  }

  addNewItemSelected(bool isExpense, String newItemSelected) async {
    if (isExpense) {
      var oldList = appController.prefs?.getStringList('customListExpenseGenre') ?? [];
      await appController.prefs?.setStringList('customListExpenseGenre', [...oldList, newItemSelected]);
      appController.loadItemSelectedList();
      setState(() {
        currentItemSelected = newItemSelected;
        contentC.text = newItemSelected;
      });
    } else {
      var oldList = appController.prefs?.getStringList('customListIncomeType') ?? [];
      await appController.prefs?.setStringList('customListIncomeType', [...oldList, newItemSelected]);
      appController.loadItemSelectedList();
      setState(() {
        currentItemSelected = newItemSelected;
        contentC.text = newItemSelected;
      });
    }
  }

  showDialogConfirmDelete(String item) {
    Widget content = Text(
      "form.dialog.deleteItemSelected.content".tr,
      style: const TextStyle(color: Colors.white),
    );
    deleteItem() {
      if (isExpense) {
        var list = appController.listGenre;
        list.remove(item);
        appController.listGenre.value = [...list];
        appController.prefs?.setStringList('customListExpenseGenre', [...list]);
      } else {
        var list = appController.listType;
        list.remove(item);
        appController.listType.value = [...list];
        appController.prefs?.setStringList('customListIncomeType', [...list]);
      }
    }
    showAppDialog(title: "form.dialog.deleteItemSelected.title".tr, content: content, confirm: deleteItem);
  }
}
