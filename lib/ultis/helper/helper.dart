import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/constant.dart';

class Helper {
  double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }

  Color getItemTypeColor(String type) {
    var color = AppColor.gold;
    if (type == 'form.genre.mustHave' || type == 'form.genre.mustHave'.tr) {
      color = AppColor.mustHave;
    }
    if (type == 'form.genre.niceToHave' || type == 'form.genre.niceToHave'.tr) {
      color = AppColor.niceToHave;
    }
    if (type == 'form.genre.wasted' || type == 'form.genre.wasted'.tr) {
      color = AppColor.wasted;
    }
    if (type == 'form.type.cash' || type == 'form.type.cash'.tr) {
      color = AppColor.pink;
    }
    if (type == 'form.type.bank' || type == 'form.type.bank'.tr) {
      color = Colors.blue;
    }
    if (type == 'form.type.eWallet' || type == 'form.type.eWallet'.tr) {
      color = AppColor.gold;
    }
    return color;
  }
}
