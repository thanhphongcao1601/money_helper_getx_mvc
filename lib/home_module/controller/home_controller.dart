import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/record.dart';

class HomeController extends GetxController {
  final listRecord = RxList<Record>([]).obs;

  final listRecordGroupByDate = RxMap<String, List<Record>>({}).obs;
  final listRecordGroupByGenre = RxMap<String, List<Record>>({}).obs;
  final listRecordGroupByType = RxMap<String, List<Record>>({}).obs;

  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;

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
    listRecord.value.clear();
    totalExpense.value = 0;
    totalIncome.value = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];

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
    String stringRecord = listStringRecord
        .firstWhere((element) => Record.fromJson(jsonDecode(element)).id == id);

    listStringRecord.remove(stringRecord);
    await prefs.setStringList('listRecord', listStringRecord);
    loadListRecord();
  }
}
