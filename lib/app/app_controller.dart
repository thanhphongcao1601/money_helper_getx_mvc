import 'dart:io';
import 'dart:ui';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:money_helper_getx_mvc/api/google_drive_app_data.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:money_helper_getx_mvc/module/home_module/model/record.dart';

class AppController extends GetxController {
  GoogleDriveAppData googleDriveAppData = GoogleDriveAppData();
  GoogleSignInAccount? googleUser;
  drive.DriveApi? driveApi;

  final listRecord = RxList<Record>([]).obs;
  List<String> listStringRecord = [];
  RxInt totalIncome = 0.obs;
  RxInt totalExpense = 0.obs;

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

  init() async {
    isLoading.value = true;
    prefs = await SharedPreferences.getInstance();
    isLockApp.value = prefs?.getBool('isLockApp') ?? false;
    isLogged.value = prefs?.getBool('isLogged') ?? false;

    await getUserLoggedInfo();
    await loadListStringRecord();
    await calculateRecord(listStringRecord);
    await loadListFileBackUp();

    String languageCode = prefs?.getString('languageCode') ?? '';
    if (languageCode != '') {
      Get.updateLocale(Locale(languageCode));
    }
    isLoading.value = false;
  }

  getUserLoggedInfo() {
    userDisplayName.value = prefs?.getString('displayName') ?? '';
    userId.value = prefs?.getString('id') ?? '';
    userEmail.value = prefs?.getString('email') ?? '';
    userPhotoUrl.value = prefs?.getString('photoUrl') ?? '';
  }

  signIn() async {
    isLoading.value = true;
    var account = await googleDriveAppData.signInGoogle();
    if (account != null) {
      driveApi = await googleDriveAppData.getDriveApi(account);

      prefs?.setBool('isLogged', true);
      prefs?.setString('id', account.id);
      prefs?.setString('email', account.email);
      prefs?.setString('displayName', account.displayName ?? "");
      prefs?.setString('photoUrl', account.photoUrl ?? "");

      isLogged.value = true;
      userDisplayName.value = account.displayName ?? '';
      userId.value = account.id;
      userEmail.value = account.email;
      userPhotoUrl.value = account.photoUrl ?? '';
    }
    isLoading.value = false;
  }

  signOut() {
    isLoading.value = true;
    googleDriveAppData.signOut();

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

    isLoading.value = false;
  }

  restoreDataFromBackUpFile(String response) async {
    List<Record> listRecord = [];

    listRecord =
        (json.decode(response) as List).map((i) => Record.fromJson(i)).toList();
    listStringRecord = [];
    for (var record in listRecord) {
      String recordJson = jsonEncode(record.toJson());
      listStringRecord.add(recordJson);
    }
    calculateRecord(listStringRecord);

    await prefs!.setStringList('listRecord', listStringRecord);
    isLoading.value = false;
  }

  loadListFileBackUp() async {
    var account = await googleDriveAppData.signInGoogle();
    if (account != null) {
      driveApi = await googleDriveAppData.getDriveApi(account);
      listBackUpFile.value =
          await googleDriveAppData.getListDriveFile(driveApi!);
    }
  }

  handleRestore(String fileName) async {
    Get.back();
    Get.back();
    isLoading.value = true;
    var fileBackUp = await googleDriveAppData.getDriveFile(driveApi!, fileName);
    if (fileBackUp != null) {
      var response = await googleDriveAppData.getContentFromDriveFile(
          driveApi!, fileBackUp);
      await restoreDataFromBackUpFile(response);
      Get.snackbar("snackbar.restore.success.title".tr,
          "snackbar.restore.success.message".tr,
          colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
    } else {
      Get.snackbar(
          "snackbar.restore.fail.title".tr, "snackbar.restore.fail.message".tr,
          colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
    }
    isLoading.value = false;
  }

  handleBackUp() async {
    Get.back();
    isLoading.value = true;
    loadListStringRecord();
    var account = await googleDriveAppData.signInGoogle();
    if (account != null) {
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

      drive.File? response = await googleDriveAppData.uploadDriveFile(
          driveApi: driveApi!, file: outputFile);
      if (response != null) {
        Get.snackbar("snackbar.backup.success.title".tr,
            "snackbar.backup.success.message".tr,
            colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
        loadListFileBackUp();
      } else {
        Get.snackbar(
            "snackbar.backup.fail.title".tr, "snackbar.backup.fail.message".tr,
            colorText: AppColor.darkPurple, backgroundColor: AppColor.gold);
      }
    }
    isLoading.value = false;
  }

  handleToggleLockApp(bool isLock) async {
    isLockApp.value = isLock;
    await prefs?.setBool('isLockApp', isLock);
  }

  loadListStringRecord() async {
    listStringRecord = (prefs?.getStringList('listRecord') ?? []);
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

  Map<String, String> listMapLanguageAndCode = {
    'English': 'en',
    'Tiếng Việt': 'vi',
  };

  changeLanguage(String languageCode) {
    prefs?.setString('languageCode', languageCode);
    Get.updateLocale(Locale(languageCode));
    Get.back();
  }
}
