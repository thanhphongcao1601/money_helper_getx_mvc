import 'dart:convert';
import 'dart:ui';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/module/home_module/model/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  final listRecord = RxList<Record>([]).obs;
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  final isDarkMode = false.obs;
  RxInt currentPageIndex = 0.obs;
  RxString currentLanguageCode = 'English'.obs;

  getListRecordFromPrefs() async {
    print('--------------AppController-------------');

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
  }

  addRecordToPrefs(Record record) async {
    String recordJson = jsonEncode(record.toJson());

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    listStringRecord.add(recordJson);

    await prefs.setStringList('listRecord', listStringRecord);
    await getListRecordFromPrefs();
  }

  deleteRecordById(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> listStringRecord = prefs.getStringList('listRecord') ?? [];
    String deletedRecord = listStringRecord
        .firstWhere((element) => Record.fromJson(jsonDecode(element)).id == id);
    listStringRecord.remove(deletedRecord);

    await prefs.setStringList('listRecord', listStringRecord);
    await getListRecordFromPrefs();
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
    await getListRecordFromPrefs();
  }

  dynamic changePage(int? newIndex) {
    currentPageIndex.value = newIndex!;
  }

  List<String> listLangue = [
    'Tiếng Việt',
    'English',
  ];

  Map<String, String> listMapLanguageAndCode = {
    'Tiếng Việt': 'vi',
    'English': 'en'
  };

  changeLanguage(String language) {
    var code = listMapLanguageAndCode[language]!;
    currentLanguageCode.value = language;
    Get.updateLocale(Locale(code));
  }
}
