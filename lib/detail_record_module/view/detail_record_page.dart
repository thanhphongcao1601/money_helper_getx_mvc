import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:money_helper_getx_mvc/home_module/controller/home_controller.dart';
import '../../home_module/model/record.dart';
import '../../ultis/constants/constant.dart';
import '../../ultis/widgets/item_select.dart';

class DetailRecordPage extends StatefulWidget {
  const DetailRecordPage({Key? key, required this.record}) : super(key: key);
  final Record record;

  @override
  State<DetailRecordPage> createState() => _DetailRecordPageState();
}

class _DetailRecordPageState extends State<DetailRecordPage>
    with TickerProviderStateMixin {
  final homeController = Get.find<HomeController>();

  final formKeyExpense = GlobalKey<FormState>();
  final formKeyIncome = GlobalKey<FormState>();

  late bool isExpense;
  late bool showGenre;
  late bool showExpenseType;

  late TextEditingController datetimeC;
  late TextEditingController expenseTypeC;
  late TextEditingController genreC;
  late TextEditingController contentC;
  late TextEditingController moneyC;

  late DateTime dateTime;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    isExpense = true;
    showGenre = false;
    showExpenseType = true;

    datetimeC = TextEditingController();
    expenseTypeC = TextEditingController();
    genreC = TextEditingController();
    contentC = TextEditingController();
    moneyC = TextEditingController();

    moneyC.text = (widget.record.money!).abs().toString();
    datetimeC.text =
        DateTime.fromMillisecondsSinceEpoch(widget.record.datetime ?? 0)
            .toString();
    expenseTypeC.text = widget.record.type ?? "";
    genreC.text = widget.record.genre ?? "";
    contentC.text = widget.record.content ?? "";
    dateTime = DateTime.fromMillisecondsSinceEpoch(widget.record.datetime ?? 0);

    _tabController = TabController(length: 2, vsync: this);
    widget.record.money! >= 0
        ? _tabController.index = 1
        : _tabController.index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(),
          ),
          title: const Text(
            "Qu???n l?? chi ti??u",
          ),
          bottom: TabBar(
              controller: _tabController,
              tabs: const [Tab(text: "Chi"), Tab(text: "Thu")]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [buildTabExpense(), buildTabIncome()],
        ));
  }

  Widget buildTabExpense() {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKeyExpense,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildDateTimeField(),
                buildMoneyTypeField(),
                buildGenreField(),
                buildMoneyValueField(),
                buildContentField(),
                const SizedBox(
                  height: 20,
                ),
                buildActionButton()
              ],
            ),
          )),
    );
  }

  Widget buildDateTimeField() {
    return DateTimeField(
      style: const TextStyle(fontWeight: FontWeight.bold),
      initialValue: dateTime,
      decoration: const InputDecoration(
          icon: Icon(
            Icons.date_range,
          ),
          hintText: 'Nh???p ng??y v?? gi???',
          labelText: 'Ng??y v?? gi???',
          border: InputBorder.none),
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
            initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
          );
          dateTime = DateTimeField.combine(date, time);
          return dateTime;
        } else {
          return currentValue;
        }
      },
    );
  }

  Widget buildMoneyTypeField() {
    return Column(
      children: [
        TextFormField(
          style: const TextStyle(fontWeight: FontWeight.bold),
          autofocus: true,
          onTap: () {
            setState(() {
              showExpenseType = !showExpenseType;
              showGenre = false;
            });
          },
          readOnly: true,
          controller: expenseTypeC,
          decoration: const InputDecoration(
              icon: Icon(
                Icons.local_atm,
              ),
              hintText: 'Ch???n lo???i t??i kho???n b??n d?????i',
              labelText: 'Lo???i t??i kho???n',
              border: InputBorder.none),
        ),
        showExpenseType
            ? GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 3 / 1,
                children: [
                  for (var item in AppConstantList.listExpenseType)
                    ItemSelect(
                        item,
                        expenseTypeC,
                        () => {
                              setState(() {
                                showExpenseType = false;
                              })
                            })
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget buildGenreField() {
    return Column(
      children: [
        TextFormField(
          style: const TextStyle(fontWeight: FontWeight.bold),
          onTap: () {
            setState(() {
              showGenre = !showGenre;
              showExpenseType = false;
            });
          },
          readOnly: true,
          controller: genreC,
          decoration: const InputDecoration(
              icon: Icon(
                Icons.category,
              ),
              hintText: 'Ch???n th??? lo???i b??n d?????i',
              labelText: 'Th??? lo???i',
              border: InputBorder.none),
        ),
        showGenre
            ? GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                childAspectRatio: 3 / 1,
                children: [
                  for (var item in AppConstantList.listGenre)
                    ItemSelect(
                        item,
                        genreC,
                        () => {
                              setState(() {
                                showGenre = false;
                              })
                            })
                ],
              )
            : const SizedBox(),
      ],
    );
  }

  Widget buildMoneyValueField() {
    return TextFormField(
      style: const TextStyle(fontWeight: FontWeight.bold),
      onTap: () {
        setState(() {
          moneyC.text = "";
          showGenre = false;
          showExpenseType = false;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'S??? ti???n kh??ng ???????c ????? tr???ng';
        }
        return null;
      },
      controller: moneyC,
      keyboardType: TextInputType.number,
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      decoration: const InputDecoration(
          icon: Icon(
            Icons.money,
          ),
          hintText: 'Nh???p s??? ti???n',
          labelText: 'S??? ti???n',
          border: InputBorder.none),
    );
  }

  Widget buildContentField() {
    return TextFormField(
      style: const TextStyle(fontWeight: FontWeight.bold),
      textInputAction: TextInputAction.next,
      onTap: () {
        setState(() {
          showGenre = false;
          showExpenseType = false;
        });
      },
      controller: contentC,
      decoration: const InputDecoration(
          icon: Icon(
            Icons.edit_note,
          ),
          hintText: 'Nh???p n???i dung',
          labelText: 'N???i dung',
          border: InputBorder.none),
    );
  }

  Widget buildActionButton() {
    return Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
              child: ElevatedButton(
            onPressed: () async {
              handleConfirmAndDelete();
            },
            child: const Text(
              'X??a',
            ),
          )),
          const SizedBox(
            width: 20,
          ),
          Expanded(
              child: ElevatedButton(
            onPressed: () async {
              handleUpdateRecord();
            },
            child: const Text(
              'L??u',
            ),
          )),
        ],
      ),
    );
  }

  void handleUpdateRecord() {
    homeController.deleteRecordById(widget.record.id!);
    if (_tabController.index == 0) {
      final recordExpense = Record(
          id: widget.record.id,
          type: expenseTypeC.text,
          datetime: dateTime.millisecondsSinceEpoch,
          genre: genreC.text,
          content: contentC.text,
          money: -int.parse(moneyC.text));

      homeController.addRecordToPrefs(recordExpense);
    } else {
      final recordIncome = Record(
          id: widget.record.id,
          type: expenseTypeC.text,
          datetime: dateTime.millisecondsSinceEpoch,
          content: contentC.text,
          money: int.parse(moneyC.text));
      homeController.addRecordToPrefs(recordIncome);
    }
    Get.back();
    Get.snackbar("Th??nh c??ng", "B???n ???? c???p nh???t th??nh c??ng",
        backgroundColor: Theme.of(context).backgroundColor);
  }

  void handleConfirmAndDelete() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      content: const Text(
          "D??? li??u b??? x??a s??? kh??ng th??? kh??i ph???c ??u b??? x??a s??? kh??ng th??? kh??i p"),
      title: "X??a b???n ghi?",
      confirm: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor),
          onPressed: () {
            if (_tabController.index == 0) {
              if (formKeyExpense.currentState!.validate()) {
                homeController.deleteRecordById(widget.record.id!);
              }
            } else {
              if (formKeyIncome.currentState!.validate()) {
                homeController.deleteRecordById(widget.record.id!);
              }
            }
            Get.back();
            Get.back();
          },
          child: const Text("X??a")),
      cancel: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.background),
          onPressed: () {
            Get.back();
          },
          child: const Text("H???y")),
    );
  }

  Widget buildTabIncome() {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKeyIncome,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                buildDateTimeField(),
                buildMoneyTypeField(),
                buildMoneyValueField(),
                buildContentField(),
                const SizedBox(
                  height: 20,
                ),
                buildActionButton()
              ],
            ),
          )),
    );
  }
}
