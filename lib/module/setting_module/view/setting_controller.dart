import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingController extends GetxController {
  final backUpType = 'day'.obs;
  final isAutoBackUpCheckBox = false.obs;
  SharedPreferences? prefs;

  init() async {
    prefs = await SharedPreferences.getInstance();
    backUpType.value = prefs?.getString('backUpType') ?? 'day';
    isAutoBackUpCheckBox.value = prefs?.getBool('isAutoBackUp') ?? false;
  }

  changeBackUpType(String type) async {
    backUpType.value = type;
    prefs?.setString('backUpType', type);
  }

  changeIsAutoBackUpCheckBox(bool value) {
    isAutoBackUpCheckBox.value = value;
    prefs?.setBool('isAutoBackUp', value);
  }
}
