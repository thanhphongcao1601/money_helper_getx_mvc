import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/models/daily_record.dart';
import '../../models/record.dart';

class HomeController extends GetxController {
  AppController appController = Get.find();
  final currentDate = DateTime.now().obs;

  final totalMonthIncome = 0.obs;
  final totalMonthExpense = 0.obs;
  final listRecordByMonth = RxList<Record>([]).obs;

  final listRecordGroupByDate = RxList<DailyRecord>([]).obs;
  final listMapMoneyByType = RxList<Map<String, int>>([]).obs;

  init() {
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
    groupRecordByType(listRecordByMonth.value);
  }

  void handleHomeChangeMonthYear(DateTime selectedMonthYear) {
    currentDate.value = selectedMonthYear;
    loadAllData();
  }

  getListRecordByMonth(DateTime selectedMonthYear) {
    RxList<Record> listRecordByMonth = RxList<Record>([]);
    for (var record in appController.listRecord.value) {
      if (!(record.isLoan == true)) {
        if (DateTime.fromMillisecondsSinceEpoch(record.datetime!).month == selectedMonthYear.month &&
            DateTime.fromMillisecondsSinceEpoch(record.datetime!).year == selectedMonthYear.year) {
          listRecordByMonth.add(record);
        }
      }
    }
    listRecordByMonth.sortReversed();
    return listRecordByMonth;
  }

  groupRecordByDate(List<Record> recordList) {
    listRecordGroupByDate.value.clear();
    var groups = groupBy(recordList, (Record e) {
      DateTime tsDate = DateTime.fromMillisecondsSinceEpoch(e.datetime!);
      String datetime = tsDate.toString().substring(0, 10);
      return datetime;
    });

    for (var item in groups.entries) {
      DailyRecord dailyRecord = DailyRecord(date: item.key, listRecord: item.value);
      listRecordGroupByDate.value.add(dailyRecord);
    }
  }

  groupRecordByType(List<Record> recordList) {
    listMapMoneyByType.value.clear();
    var groups = groupBy(recordList, (Record e) => e.type!);

    for (var item in groups.entries) {
      String key = item.key;
      int value = item.value.sumBy((element) => element.money ?? 0);
      listMapMoneyByType.value.add({key: value});
      print({key: value});
    }
  }
}
