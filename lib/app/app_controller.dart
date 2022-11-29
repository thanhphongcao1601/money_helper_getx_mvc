import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:money_helper_getx_mvc/api/google_drive_app_data.dart';
import 'package:money_helper_getx_mvc/module/home_module/home_controller.dart';
import 'package:money_helper_getx_mvc/module/loan_module/loan_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:money_helper_getx_mvc/models/record.dart';

class AppController extends GetxController {
  GoogleDriveAppData googleDriveAppData = GoogleDriveAppData();
  GoogleSignInAccount? googleUser;
  drive.DriveApi? driveApi;

  final listRecord = RxList<Record>([]).obs;
  List<String> listStringRecord = [];
  // RxInt totalIncome = 0.obs;
  // RxInt totalExpense = 0.obs;

  RxBool isDarkMode = false.obs;
  RxBool isLockApp = false.obs;
  RxBool isLogged = false.obs;
  RxInt currentPageIndex = 0.obs;
  RxString currentLanguageCode = 'English'.obs;

  SharedPreferences? prefs;
  RxBool isLoading = false.obs;

  final userDisplayName = ''.obs;
  final userId = ''.obs;
  final userEmail = ''.obs;
  final userPhotoUrl = ''.obs;

  final listBackUpFile = <drive.File?>[].obs;

  final listGenre = <String>[].obs;
  final listType = <String>[].obs;

  Future init() async {
    isLoading.value = true;
    prefs = await SharedPreferences.getInstance();
    isLockApp.value = prefs?.getBool('isLockApp') ?? false;

    getUserLoggedInfo();
    await loadListStringRecord();
    calculateRecord(listStringRecord);
    loadItemSelectedList();
    await autoBackUp();

    isLoading.value = false;
  }

  void loadItemSelectedList() {
    List<String> rootListExpenseGenre = AppConstantList.listExpenseGenre;
    List<String> rootListIncomeType = AppConstantList.listIncomeType;

    List<String> customListExpenseGenre = prefs?.getStringList('customListExpenseGenre') ?? [];
    List<String> customListIncomeType = prefs?.getStringList('customListIncomeType') ?? [];

    if (customListExpenseGenre.isEmpty) {
      listGenre.value = rootListExpenseGenre;
    } else {
      listGenre.value = customListExpenseGenre;
    }

    if (customListIncomeType.isEmpty) {
      listType.value = rootListIncomeType;
    } else {
      listType.value = customListIncomeType;
    }
  }

  Future loadLanguage() async {
    prefs = await SharedPreferences.getInstance();
    String languageCode = prefs?.getString('languageCode') ?? '';
    if (languageCode != '') {
      Get.updateLocale(Locale(languageCode));
    }
  }

  Future autoBackUp() async {
    bool isAutoBackUp = prefs?.getBool('isAutoBackUp') ?? false;
    await loadListFileBackUp();
    if (isLogged.value && isAutoBackUp) {
      final today = DateTime.now();
      //check auto backup already today
      if (listBackUpFile.isEmpty) return;
      if (listBackUpFile[0]!.modifiedTime!.day != today.day) {
        handleBackUp();
      }
    }
  }

  void getUserLoggedInfo() {
    isLogged.value = prefs?.getBool('isLogged') ?? false;
    userDisplayName.value = prefs?.getString('displayName') ?? '';
    userId.value = prefs?.getString('id') ?? '';
    userEmail.value = prefs?.getString('email') ?? '';
    userPhotoUrl.value = prefs?.getString('photoUrl') ?? '';
  }

  signIn() async {
    isLoading.value = true;
    var account = await googleDriveAppData.signInGoogle();
    if (account != null) {
      saveLoggedInfo(account);

      await loadListFileBackUp();
      if (listBackUpFile.isNotEmpty) {
        handleRestore(listBackUpFile.first!.name!);
      } else {
        listRecord.value.clear();
        listStringRecord.clear();
      }

      await prefs?.remove('customListExpenseGenre');
      await prefs?.remove('customListIncomeType');
    }
    isLoading.value = false;
  }

  saveLoggedInfo(GoogleSignInAccount account) {
    isLogged.value = true;

    prefs?.setBool('isLogged', true);
    prefs?.setString('id', account.id);
    prefs?.setString('email', account.email);
    prefs?.setString('displayName', account.displayName ?? "");
    prefs?.setString('photoUrl', account.photoUrl ?? "");

    userDisplayName.value = account.displayName ?? '';
    userId.value = account.id;
    userEmail.value = account.email;
    userPhotoUrl.value = account.photoUrl ?? '';
  }

  signOut() async {
    isLoading.value = true;
    clearAllData();
    googleDriveAppData.signOut();

    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  void clearAllData() {
    userDisplayName.value = '';
    userId.value = '';
    userEmail.value = '';
    userPhotoUrl.value = '';
    isLogged.value = false;

    prefs?.setBool('isLogged', false);
    prefs?.remove('id');
    prefs?.remove('email');
    prefs?.remove('displayName');
    prefs?.remove('photoUrl');
    prefs?.remove('customListExpenseGenre');
    prefs?.remove('customListIncomeType');
    prefs?.remove('listRecord');

    listBackUpFile.clear();
    listRecord.value.clear();
    listStringRecord.clear();
    isLogged.value = false;

    listGenre.value = AppConstantList.listExpenseGenre;
    listType.value = AppConstantList.listIncomeType;
  }

  Future restoreDataFromBackUpFile(String response) async {
    List<Record> listRecord = [];

    listRecord = (json.decode(response) as List).map((i) => Record.fromJson(i)).toList();
    listStringRecord = [];
    for (var record in listRecord) {
      String recordJson = jsonEncode(record.toJson());
      listStringRecord.add(recordJson);
    }
    calculateRecord(listStringRecord);

    await prefs!.setStringList('listRecord', listStringRecord);
    isLoading.value = false;
  }

  Future loadListFileBackUp() async {
    if (isLogged.value) {
      var account = await googleDriveAppData.signInGoogle();
      if (account != null) {
        driveApi = await googleDriveAppData.getDriveApi(account);
        DateTime now = DateTime.now();
        DateTime limitDate = now.subtract(const Duration(days: 7));
        listBackUpFile.value = await googleDriveAppData.getListDriveFile(driveApi!);

        var newList = <drive.File>[];
        for (var file in listBackUpFile) {
          if (file!.modifiedTime!.toLocal().isBefore(limitDate)) {
            listBackUpFile.remove(file);
            await googleDriveAppData.deleteDriveFile(driveApi!, file.name!);
          } else {
            newList.add(file);
          }
        }
        listBackUpFile.value = newList;
      }
    }
  }

  Future handleRestore(String fileName) async {
    Get.back(closeOverlays: true);
    isLoading.value = true;
    var fileBackUp = await googleDriveAppData.getDriveFile(driveApi!, fileName);
    if (fileBackUp != null) {
      var response = await googleDriveAppData.getContentFromDriveFile(driveApi!, fileBackUp);
      await restoreDataFromBackUpFile(response);
      Get.snackbar("snackbar.restore.success.title".tr, "snackbar.restore.success.message".tr,
          duration: const Duration(seconds: 1), colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
    } else {
      Get.snackbar("snackbar.restore.fail.title".tr, "snackbar.restore.fail.message".tr,
          duration: const Duration(seconds: 1), colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
    }
    isLoading.value = false;
  }

  handleBackUp() async {
    Get.back(closeOverlays: true);
    isLoading.value = true;
    loadListStringRecord();

    var account = await googleDriveAppData.signInGoogle();

    if (account != null) {
      saveLoggedInfo(account);

      driveApi = await googleDriveAppData.getDriveApi(account);
      //create a file
      //create directory path
      final tempDirectory = await getTemporaryDirectory();
      String appDocPath = tempDirectory.path;
      //create name of file
      DateTime tsDate = DateTime.now();
      String fileBackUpName = "MMB_$tsDate.txt";
      File file = File('$appDocPath/$fileBackUpName');
      //write data to file
      file.writeAsString(listStringRecord.toString());

      File outputFile = await file.create();

      drive.File? response = await googleDriveAppData.uploadDriveFile(driveApi: driveApi!, file: outputFile);
      if (response != null) {
        Get.snackbar("snackbar.backup.success.title".tr, "snackbar.backup.success.message".tr,
            duration: const Duration(seconds: 1), colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
        loadListFileBackUp();
      } else {
        Get.snackbar("snackbar.backup.fail.title".tr, "snackbar.backup.fail.message".tr,
            duration: const Duration(seconds: 1), colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
      }
    }
    isLoading.value = false;
  }

  Future handleToggleLockApp(bool isLock) async {
    isLockApp.value = isLock;
    await prefs?.setBool('isLockApp', isLock);
  }

  Future loadListStringRecord() async {
    listStringRecord = (prefs?.getStringList('listRecord') ?? []);
  }

  Future<void> calculateRecord(List<String> listStringRecord) async {
    listRecord.value.clear();
    // totalExpense.value = 0;
    // totalIncome.value = 0;
    for (var strRecord in listStringRecord) {
      Record record = Record.fromJson(jsonDecode(strRecord));
      int money = record.money ?? 0;
      if (money > 0) {
        // totalIncome += money;
        if (!listType.contains(record.type)) {
          if (record.type != null) {
            listType.value = [...listType, record.type!];
          }
        }
      }
      if (money < 0) {
        // totalExpense += money;
        if (!listGenre.contains(record.genre)) {
          if (record.genre != null) {
            listGenre.value = [...listGenre, record.genre!];
          }
        }
      }
      listRecord.value.add(record);
    }
    await prefs?.setStringList('customListIncomeType', [...listType]);
    await prefs?.setStringList('customListExpenseGenre', [...listGenre]);

    listRecord.value.sortReversed();
    HomeController homeController = Get.find();
    LoanController loanController = Get.put(LoanController());
    homeController.init();
    loanController.init();
  }

  Future addRecord(Record record) async {
    listRecord.value.add(record);
    String recordJson = jsonEncode(record.toJson());

    listStringRecord.add(recordJson);
    await prefs!.setStringList('listRecord', listStringRecord);
  }

  Future deleteRecord(Record record) async {
    listRecord.value.remove(record);
    String deletedRecord =
        listStringRecord.firstWhere((element) => Record.fromJson(jsonDecode(element)).id == record.id);
    listStringRecord.remove(deletedRecord);
    await prefs!.setStringList('listRecord', listStringRecord);
  }

  Future updateRecord(Record record) async {
    var deletedRecord = listRecord.value.firstWhere((element) => element.id == record.id);
    listRecord.value.remove(deletedRecord);
    listRecord.value.add(record);

    String recordJson = jsonEncode(record.toJson());

    String deletedStringRecord =
        listStringRecord.firstWhere((element) => Record.fromJson(jsonDecode(element)).id == record.id);

    listStringRecord.remove(deletedStringRecord);
    listStringRecord.add(recordJson);

    await prefs!.setStringList('listRecord', listStringRecord);
  }

  void changePage(int? newIndex) {
    currentPageIndex.value = newIndex!;
  }

  Map<String, String> listMapLanguageAndCode = {
    'English': 'en',
    'Tiếng Việt': 'vi',
  };

  void changeLanguage(String languageCode) {
    prefs?.setString('languageCode', languageCode);
    Get.updateLocale(Locale(languageCode));
    Get.back(closeOverlays: true);
  }
}
