import 'package:get/get.dart';

class AppController extends GetxController {
  final isDarkMode = false.obs;
  RxInt currentIndex = 0.obs;

  dynamic changePage(int? newIndex) {
    currentIndex.value = newIndex!;
  }
}
