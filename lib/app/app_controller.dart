import 'dart:convert';
import 'dart:ui';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/module/home_module/model/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppController extends GetxController {
  final listRecord = RxList<Record>([]).obs;
  List<String> listStringRecord = [];
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;
  final isDarkMode = false.obs;
  RxInt currentPageIndex = 0.obs;
  RxString currentLanguageCode = 'English'.obs;
  SharedPreferences? prefs;
  RxBool isLockApp = false.obs;

  final userDisplayName = ''.obs;
  final userId = ''.obs;
  final userEmail = ''.obs;
  final userPhotoUrl = ''.obs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    isLockApp.value = prefs?.getBool('isLockApp') ?? false;
    await initUserLogin();
    await initListStringRecord();
    await calculateRecord(listStringRecord);
  }

  initUserLogin() {
    userDisplayName.value = prefs?.getString('displayName') ?? '';
    userId.value = prefs?.getString('id') ?? '';
    userEmail.value = prefs?.getString('email') ?? '';
    userPhotoUrl.value = prefs?.getString('photoUrl') ?? '';
  }

  handleToggleLockApp(bool isLock) async {
    isLockApp.value = isLock;
    await prefs?.setBool('isLockApp', isLock);
  }

  initListStringRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    listStringRecord = (prefs.getStringList('listRecord') ?? []);
  }

  calculateRecord(List<String> listStringRecord) {
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

  addRecord(Record record) async {
    listRecord.value.add(record);
    String recordJson = jsonEncode(record.toJson());

    listStringRecord.add(recordJson);
    await prefs!.setStringList('listRecord', listStringRecord);
  }

  deleteRecord(Record record) async {
    listRecord.value.remove(record);
    String deletedRecord = listStringRecord.firstWhere(
        (element) => Record.fromJson(jsonDecode(element)).id == record.id);
    listStringRecord.remove(deletedRecord);
    await prefs!.setStringList('listRecord', listStringRecord);
  }

  updateRecord(Record record) async {
    var deletedRecord =
        listRecord.value.firstWhere((element) => element.id == record.id);
    listRecord.value.remove(deletedRecord);
    listRecord.value.add(record);

    String recordJson = jsonEncode(record.toJson());

    String deletedStringRecord = listStringRecord.firstWhere(
        (element) => Record.fromJson(jsonDecode(element)).id == record.id);

    listStringRecord.remove(deletedStringRecord);
    listStringRecord.add(recordJson);

    await prefs!.setStringList('listRecord', listStringRecord);
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
