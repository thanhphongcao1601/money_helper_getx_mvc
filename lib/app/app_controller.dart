import 'dart:ui';
import 'dart:convert';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:money_helper_getx_mvc/api/google_drive_app_data.dart';
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

  final isDarkMode = false.obs;
  RxInt currentPageIndex = 0.obs;
  RxString currentLanguageCode = 'English'.obs;
  RxBool isLockApp = false.obs;

  SharedPreferences? prefs;

  final userDisplayName = ''.obs;
  final userId = ''.obs;
  final userEmail = ''.obs;
  final userPhotoUrl = ''.obs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    isLockApp.value = prefs?.getBool('isLockApp') ?? false;
    await initUserLogin();
    await getListStringRecord();
    await calculateRecord(listStringRecord);
  }

  initUserLogin() {
    userDisplayName.value = prefs?.getString('displayName') ?? '';
    userId.value = prefs?.getString('id') ?? '';
    userEmail.value = prefs?.getString('email') ?? '';
    userPhotoUrl.value = prefs?.getString('photoUrl') ?? '';
  }

  signIn() async {
    var account = await googleDriveAppData.signInGoogle();
    if (account != null) {
      prefs?.setBool('isLogged', true);
      prefs?.setString('id', account.id);
      prefs?.setString('email', account.email);
      prefs?.setString('displayName', account.displayName ?? "");
      prefs?.setString('photoUrl', account.photoUrl ?? "");
    }
  }

  signOut() {
    googleDriveAppData.signOut();
    prefs?.setBool('isLogged', false);
    prefs?.remove('id');
    prefs?.remove('email');
    prefs?.remove('displayName');
    prefs?.remove('photoUrl');
  }

  handleBackUp() async {
    await getListStringRecord();
    String jsonListRecord = jsonEncode(listStringRecord);

    final FileSystem fs = MemoryFileSystem();
    final Directory tmp =
        await fs.systemTempDirectory.createTemp('systemTempDirectory_');
    final File outputFile = tmp.childFile('money_manager_backup_file.txt');
    await outputFile.writeAsString(jsonListRecord);
    print(jsonListRecord);

    googleDriveAppData.uploadDriveFile(
      driveApi: driveApi!,
      file: outputFile,
    );
  }

  handleToggleLockApp(bool isLock) async {
    isLockApp.value = isLock;
    await prefs?.setBool('isLockApp', isLock);
  }

  getListStringRecord() async {
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
