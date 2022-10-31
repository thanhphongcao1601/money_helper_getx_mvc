import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';
import 'package:money_helper_getx_mvc/module/home_module/model/daily_record.dart';
import 'package:money_helper_getx_mvc/ultis/helper/helper.dart';
import '../model/record.dart';

class HomeController extends GetxController {
  AppController appController = Get.put(AppController());
  final currentDate = DateTime.now().obs;
  final totalMonthIncome = 0.obs;
  final totalMonthExpense = 0.obs;
  final listRecordByMonth = RxList<Record>([]).obs;

  final listRecordGroupByDate = RxList<DailyRecord>([]).obs;
  final mapGenreListRecord = RxMap<String, List<Record>>({}).obs;
  final mapTypeListRecord = RxMap<String, List<Record>>({}).obs;

  final dataExpenseToChart = RxList<Map<String, dynamic>>([]).obs;
  final dataIncomeToChart = RxList<Map<String, dynamic>>([]).obs;

  loadAllData() async {
    await appController.getListRecordFromPrefs();
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

    //data of statistic page
    mapGenreListRecord.value =
        getMapGenreListRecord(appController.listRecord.value);
    mapTypeListRecord.value =
        getMapTypeListRecord(appController.listRecord.value);
    addDataToChart();
  }

  void handleHomeChangeMonthYear(DateTime selectedMonthYear) {
    groupRecordByDate(getListRecordByMonth(selectedMonthYear));
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
    return listRecordByMonth;
  }

  addDataToChart() {
    dataExpenseToChart.value.clear();
    dataIncomeToChart.value.clear();

    //add expense item to expenseChart
    for (var item in mapGenreListRecord.value.entries) {
      for (var record in item.value) {
        if (record.money! < 0 && totalMonthExpense.value != 0) {
          Map<String, dynamic> obj = {
            'domain': item.key.toString().tr,
            'measure': Helper().roundDouble(
                (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0) /
                    totalMonthExpense.value *
                    100),
                2),
            'money': (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0))
          };
          if (!dataExpenseToChart.value
              .any((element) => element['domain'] == obj['domain'])) {
            dataExpenseToChart.value.add(obj);
          }
        }
      }
    }

    //add income item to incomeChart
    for (var item in mapTypeListRecord.value.entries) {
      for (var record in item.value) {
        if (record.money! > 0 && totalMonthExpense.value != 0) {
          Map<String, dynamic> obj = {
            'domain': item.key.toString().tr,
            'measure': Helper().roundDouble(
                (item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0) /
                    totalMonthIncome.value *
                    100),
                2),
            'money': item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0)
          };
          if (!dataIncomeToChart.value
              .any((element) => element['domain'] == obj['domain'])) {
            dataIncomeToChart.value.add(obj);
          }
        }
      }
    }
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
    listRecordGroupByDate.refresh();
  }

  getMapGenreListRecord(List<Record> record) {
    var groups = groupBy(record, (Record e) {
      var genre = e.genre ??= "";
      return genre;
    });
    var rxgroups = RxMap<String, List<Record>>({});
    rxgroups.value = groups;
    return rxgroups;
  }

  getMapTypeListRecord(List<Record> record) {
    Map<String, List<Record>> groups = groupBy(record, (Record e) {
      return e.type ?? "Không tiêu đề";
    });
    var rxgroups = RxMap<String, List<Record>>({});
    rxgroups.value = groups;
    return rxgroups;
  }
}
