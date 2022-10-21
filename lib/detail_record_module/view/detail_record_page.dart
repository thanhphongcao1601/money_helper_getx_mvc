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
            decoration: const BoxDecoration(
                // gradient: LinearGradient(
                //     begin: Alignment.bottomLeft,
                //     end: Alignment.topRight,
                //     colors: <Color>[
                //       Color(AppColor.pink),
                //       Color(AppColor.yellow)
                //     ]),
                ),
          ),
          title: const Text(
            "Quản lý chi tiêu",
          ),
          bottom: TabBar(
              // indicatorColor: Colors.black,
              // labelColor: Colors.black,
              controller: _tabController,
              tabs: const [
                Tab(
                  text: "Chi",
                ),
                Tab(
                  text: "Thu",
                )
              ]),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildTabExpense(),
            buildTabIncome(),
          ],
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
                DateTimeField(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  initialValue: dateTime,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.date_range,
                      ),
                      hintText: 'Nhập ngày và giờ',
                      labelText: 'Ngày và giờ',
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
                      hintText: 'Chọn loại tài khoản bên dưới',
                      labelText: 'Loại tài khoản',
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
                      hintText: 'Chọn thể loại bên dưới',
                      labelText: 'Thể loại',
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
                TextFormField(
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
                      return 'Số tiền không được để trống';
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
                      hintText: 'Nhập số tiền',
                      labelText: 'Số tiền',
                      border: InputBorder.none),
                ),
                TextFormField(
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
                      hintText: 'Nhập nội dung',
                      labelText: 'Nội dung',
                      border: InputBorder.none),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () async {
                          Get.defaultDialog(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            content: Text(
                                "Dữ liêu bị xóa sẽ không thể khôi phục êu bị xóa sẽ không thể khôi p"),
                            title: "Xóa bản ghi?",
                            confirm: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  if (formKeyIncome.currentState!.validate()) {
                                    homeController
                                        .deleteRecordById(widget.record.id!);
                                    Get.back();
                                  }
                                },
                                child: Text("Xóa")),
                            cancel: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("Hủy")),
                          );
                        },
                        child: const Text(
                          'Xóa',
                        ),
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () async {
                          if (formKeyExpense.currentState!.validate()) {
                            final record = Record(
                                id: widget.record.id,
                                type: expenseTypeC.text,
                                datetime: dateTime.millisecondsSinceEpoch,
                                genre: genreC.text,
                                content: contentC.text,
                                money: -int.parse(moneyC.text));
                            homeController.deleteRecordById(widget.record.id!);
                            homeController.addRecordToPrefs(record);
                            Get.back();
                            Get.snackbar(
                                "Thành công", "Bạn đã cập nhật thành công",
                                backgroundColor:
                                    Theme.of(context).backgroundColor);
                          }
                        },
                        child: const Text(
                          'Lưu',
                        ),
                      )),
                    ],
                  ),
                ),
              ],
            ),
          )),
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
                DateTimeField(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  initialValue: dateTime,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.date_range,
                      ),
                      hintText: 'Nhập ngày và giờ',
                      labelText: 'Ngày và giờ',
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
                      hintText: 'Chọn loại tài khoản bên dưới',
                      labelText: 'Loại tài khoản',
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
                TextFormField(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  onTap: () {
                    setState(() {
                      moneyC.text = "";
                      showExpenseType = false;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Số tiền không được bỏ trống';
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
                      hintText: 'Nhập số tiền',
                      labelText: 'Số tiền',
                      border: InputBorder.none),
                ),
                TextFormField(
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textInputAction: TextInputAction.next,
                  onTap: () {
                    setState(() {
                      showExpenseType = false;
                    });
                  },
                  controller: contentC,
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.edit_note,
                      ),
                      hintText: 'Nhập nội dung',
                      labelText: 'Nội dung',
                      border: InputBorder.none),
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () async {
                          Get.defaultDialog(
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                            content: Text(
                                "Dữ liêu bị xóa sẽ không thể khôi phục êu bị xóa sẽ không thể khôi p"),
                            title: "Xóa bản ghi?",
                            confirm: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  if (formKeyIncome.currentState!.validate()) {
                                    homeController
                                        .deleteRecordById(widget.record.id!);
                                    Get.back();
                                  }
                                },
                                child: Text("Xóa")),
                            cancel: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.background,
                                ),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text("Hủy")),
                          );
                        },
                        child: const Text(
                          'Xóa',
                        ),
                      )),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: ElevatedButton(
                        onPressed: () async {
                          if (formKeyIncome.currentState!.validate()) {
                            final record = Record(
                                id: widget.record.id,
                                type: expenseTypeC.text,
                                datetime: dateTime.millisecondsSinceEpoch,
                                genre: genreC.text,
                                content: contentC.text,
                                money: int.parse(moneyC.text));
                            homeController
                                .deleteRecordById(widget.record.id ?? "");
                            homeController.addRecordToPrefs(record);
                            Get.back();
                            Get.snackbar(
                                "Thành công", "Bạn đã cập nhật thành công",
                                backgroundColor:
                                    Theme.of(context).backgroundColor);
                          }
                        },
                        child: const Text(
                          'Lưu',
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
