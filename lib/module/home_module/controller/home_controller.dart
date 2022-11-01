import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/home_module/model/daily_record.dart';
import '../model/record.dart';

class HomeController extends GetxController {
  AppController appController = Get.find();
  final currentDate = DateTime.now().obs;

  final totalMonthIncome = 0.obs;
  final totalMonthExpense = 0.obs;
  final listRecordByMonth = RxList<Record>([]).obs;

  final listRecordGroupByDate = RxList<DailyRecord>([]).obs;

  init(){
    currentDate.value = DateTime.now();
    loadAllData();
  }

  loadAllData() async {
    totalMonthExpense.value = 0;
    totalMonthIncome.value = 0;
    listRecordByMonth.value = getListRecordByMonth(currentDate.value);

    for (var record in listRecordByMonth.value) {
      if (record.money! >= 0) {
        totalMonthIncome.value += record.money!;
      }
      if (record.money! < 0) {
        totalMonthExpense.value += record.money!;
      }
    }
    groupRecordByDate(listRecordByMonth.value);
  }

  void handleHomeChangeMonthYear(DateTime selectedMonthYear) {
    currentDate.value = selectedMonthYear;
    loadAllData();
  }

  getListRecordByMonth(DateTime selectedMonthYear) {
    RxList<Record> listRecordByMonth = RxList<Record>([]);
    for (var record in appController.listRecord.value) {
      if (DateTime.fromMillisecondsSinceEpoch(record.datetime!).month ==
              selectedMonthYear.month &&
          DateTime.fromMillisecondsSinceEpoch(record.datetime!).year ==
              selectedMonthYear.year) {
        listRecordByMonth.add(record);
      }
    }
    listRecordByMonth.sortReversed();
    return listRecordByMonth;
  }

  groupRecordByDate(List<Record> record) {
    listRecordGroupByDate.value.clear();
    var groups = groupBy(record, (Record e) {
      DateTime tsDate = DateTime.fromMillisecondsSinceEpoch(e.datetime!);
      String datetime = "${tsDate.year}/${tsDate.month}/${tsDate.day}";
      return datetime;
    });

    for (var item in groups.entries) {
      DailyRecord dailyRecord =
          DailyRecord(date: item.key, listRecord: item.value);
      listRecordGroupByDate.value.add(dailyRecord);
    }
  }
}
