import 'package:get/get.dart';

class SettingController extends GetxController {
  final backUpType = 'day'.obs;
  final isAutoBackUpCheckBox = false.obs;

  changeBackUpType(String type) {
    backUpType.value = type;
  }

  changeIsAutoBackUpCheckBox() {
    isAutoBackUpCheckBox.value = !isAutoBackUpCheckBox.value;
  }
}
