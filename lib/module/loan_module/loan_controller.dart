import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/models/record.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoanController extends GetxController {
  AppController appController = Get.find();
  final totalLend = 0.obs;
  final totalBorrow = 0.obs;
  final listLoan = RxList<Record>([]).obs;

  init() {
    loadAllData();
  }

  loadAllData() async {
    listLoan.value.clear();
    totalLend.value = 0;
    totalBorrow.value = 0;

    for (var record in appController.listRecord.value) {
      if (record.isLoan == true) {
        if (record.loanType == 'lend') {
          totalLend.value += record.money!;
        }
        if (record.loanType == 'borrow') {
          totalBorrow.value += record.money!;
        }
        listLoan.value.add(record);
      }
    }
    listLoan.value.sortReversed();
  }
}
