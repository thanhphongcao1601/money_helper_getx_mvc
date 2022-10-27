import 'package:get/get.dart';

class StatisticController extends GetxController{
  final tileSelected = ''.obs;
  
  void handleExpandTile(String domain) {
    if (domain == tileSelected.value) {
      tileSelected.value = '';
    } else {
      tileSelected.value = domain;
    }
  }
}