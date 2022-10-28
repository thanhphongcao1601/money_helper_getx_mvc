import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../ultis/helper/helper.dart';
import '../model/record.dart';

class HomeController extends GetxController {
  final listRecord = RxList<Record>([]).obs;

  final listRecordGroupByDate = RxMap<String, List<Record>>({}).obs;
  final listRecordGroupByGenre = RxMap<String, List<Record>>({}).obs;
  final listRecordGroupByType = RxMap<String, List<Record>>({}).obs;
  
  final dataExpenseToChart = RxList<Map<String, dynamic>>([]).obs;
  final dataIncomeToChart = RxList<Map<String, dynamic>>([]).obs;

  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;

  addDataToChart() {
    dataExpenseToChart.value.clear();
    dataIncomeToChart.value.clear();

    //add expense item to expenseChart
    for (var item in listRecordGroupByGenre.value.entries) {
      for (var record in item.value) {
        if (record.money! < 0 && totalExpense.value != 0) {
          Map<String, dynamic> obj = {
            'domain': item.key.toString().tr,
            'measure': Helper().roundDouble(
                (item.value.sumBy<int>((e) => e.money! < 0 ? e.money! : 0) /
                    totalExpense.value *
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
    for (var item in listRecordGroupByType.value.entries) {
      for (var record in item.value) {
        if (record.money! > 0 && totalExpense.value != 0) {
          Map<String, dynamic> obj = {
            'domain': item.key.toString().tr,
            'measure': Helper().roundDouble(
                (item.value.sumBy<int>((e) => e.money! > 0 ? e.money! : 0) /
                    totalIncome.value *
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
    var groups = groupBy(record, (Record e) {
      DateTime tsDate = DateTime.fromMillisecondsSinceEpoch(e.datetime!);
      String datetime = "${tsDate.year}/${tsDate.month}/${tsDate.day}";
      return datetime;
    });

    var rxgroups = RxMap<String, List<Record>>({});
    rxgroups.value = groups;
    return rxgroups;
  }

  groupRecordByGenre(List<Record> record) {
    var groups = groupBy(record, (Record e) {
      var genre = e.genre ??= "";
      return genre;
    });
    var rxgroups = RxMap<String, List<Record>>({});
    rxgroups.value = groups;
    return rxgroups;
  }

  groupRecordByType(List<Record> record) {
    Map<String, List<Record>> groups = groupBy(record, (Record e) {
      return e.type ?? "Không tiêu đề";
    });
    var rxgroups = RxMap<String, List<Record>>({});
    rxgroups.value = groups;
    return rxgroups;
  }

  loadListRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];

    listRecord.value.clear();
    totalExpense.value = 0;
    totalIncome.value = 0;

    for (var strRecord in listStringRecord) {
      Record record = Record.fromJson(jsonDecode(strRecord));
      int money = record.money ?? 0;
      if (money >= 0) {
        totalIncome += money;
      } else {
        totalExpense += money;
      }
      listRecord.value.add(record);
    }

      listRecord.value.sortReversed();
      listRecordGroupByDate.value = groupRecordByDate(listRecord.value);
      listRecordGroupByGenre.value = groupRecordByGenre(listRecord.value);
      listRecordGroupByType.value = groupRecordByType(listRecord.value);
      addDataToChart();
  }

  addRecordToPrefs(Record record) async {
    String recordJson = jsonEncode(record.toJson());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    listStringRecord.add(recordJson);

    await prefs.setStringList('listRecord', listStringRecord);
    loadListRecord();
  }

  deleteRecordById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    String deletedRecord = listStringRecord
        .firstWhere((element) => Record.fromJson(jsonDecode(element)).id == id);
    listStringRecord.remove(deletedRecord);

    await prefs.setStringList('listRecord', listStringRecord);
    loadListRecord();
  }

  updateRecord(Record record) async {
    String recordJson = jsonEncode(record.toJson());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];

    String deletedRecord = listStringRecord.firstWhere(
        (element) => Record.fromJson(jsonDecode(element)).id == record.id);

    listStringRecord.remove(deletedRecord);
    listStringRecord.add(recordJson);

    await prefs.setStringList('listRecord', listStringRecord);
    loadListRecord();
  }
}
