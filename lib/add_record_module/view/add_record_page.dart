import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:uuid/uuid.dart';
import '../../home_module/model/record.dart';
import '../../ultis/constants/constant.dart';

class AddRecordPage extends StatefulWidget {
  const AddRecordPage({Key? key}) : super(key: key);

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

class _AddRecordPageState extends State<AddRecordPage>
    with TickerProviderStateMixin {
  final HomeController homeController = Get.find<HomeController>();

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

  @override
  void initState() {
    super.initState();
    isExpense = true;
    currentItemGenre='';

    datetimeC = TextEditingController();
    genreC = TextEditingController();
    contentC = TextEditingController();
    moneyC = TextEditingController();

    dateTime = DateTime.now();
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
        const Text(
          'Date & Time',
          style: TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: DateTimeField(
                initialValue: dateTime,
                decoration: InputDecoration(
                  hintText: 'form.dateAndTimeHint'.tr,
                ),
                format: DateFormat("yyyy-MM-dd h:mm a"),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Type',
          style: TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: genreC,
                readOnly: true,
                decoration: const InputDecoration(
                  hintText: 'Choose type below',
                ),
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
            for (var item in AppConstantList.listGenre)
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
        const Text(
          'Money',
          style: TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: moneyC,
                keyboardType: const TextInputType.numberWithOptions(),
                decoration: const InputDecoration(
                  hintText: 'Enter money',
                ),
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
        const Text(
          'Content',
          style: TextStyle(color: AppColor.gold),
        ),
        Container(
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                controller: contentC,
                decoration: const InputDecoration(
                  hintText: 'Enter content',
                ),
              ),
            )),
      ],
    );
  }

  Widget buildSaveButton() {
    return SizedBox(
      width: Get.width / 2,
      child: ElevatedButton(
        onPressed: () {
          handleAddRecord();
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
        child: const Text(
          'Save',
          style: TextStyle(color: AppColor.darkPurple),
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
        child: const Text('Cancel', style: TextStyle(color: AppColor.gold)),
      ),
    );
  }

  Widget buildItemGenre(String item, bool isSelected) {
    return InkWell(
      onTap: ()=>chooseItem(item),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: isSelected ? AppColor.gold : Colors.grey,
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          item.tr,
          style: TextStyle(color: isSelected? AppColor.darkPurple:Colors.white),
        ),
      ),
    );
  }

  void chooseItem(String item){
    setState(() {
      currentItemGenre = item;
      genreC.text = item.tr;
    });
  }

  void handleAddRecord() {
    final recordExpense = Record(
        id: const Uuid().v4(),
        datetime: dateTime.millisecondsSinceEpoch,
        genre: genreC.text,
        content: contentC.text,
        money: -int.parse(moneyC.text));

    print(dateTime.toString() +
        '--' +
        genreC.text +
        '--' +
        contentC.text +
        '--' +
        moneyC.text);
    //homeController.addRecordToPrefs(recordExpense);

    // Get.back();
    // Get.snackbar(
    //     "snackbar.add.success.title".tr, "snackbar.add.success.message".tr,
    //     backgroundColor: Theme.of(context).backgroundColor);
  }
}
