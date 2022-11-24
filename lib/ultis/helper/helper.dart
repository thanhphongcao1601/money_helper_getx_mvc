import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../constants/constant.dart';

List<Color> colorArray = [
  const Color(0xFFFF6633),
  const Color(0xFFFFB399),
  const Color(0xFFFF33FF),
  // const Color(0xFFFFFF99),
  const Color(0xFF00B3E6),
  const Color(0xFFE6B333),
  const Color(0xFF3366E6),
  const Color(0xFF999966),
  // const Color(0xFF99FF99),
  const Color(0xFFB34D4D),
  // const Color(0xFF80B300),
  const Color(0xFF809900),
  const Color(0xFFE6B3B3),
  const Color(0xFF6680B3),
  // const Color(0xFF66991A),
  const Color(0xFFFF99E6),
  const Color(0xFFCCFF1A),
  const Color(0xFFFF1A66),
  const Color(0xFFE6331A),
  // const Color(0xFF33FFCC),
  const Color(0xFF66994D),
  const Color(0xFFB366CC),
  const Color(0xFF4D8000),
  const Color(0xFFB33300),
  const Color(0xFFCC80CC),
  const Color(0xFF66664D),
  const Color(0xFF991AFF),
  const Color(0xFFE666FF),
  const Color(0xFF4DB3FF),
  const Color(0xFF1AB399),
  const Color(0xFFE666B3),
  const Color(0xFF33991A),
  const Color(0xFFCC9999),
  const Color(0xFFB3B31A),
  const Color(0xFF00E680),
  const Color(0xFF4D8066),
  const Color(0xFF809980),
  const Color(0xFFE6FF80),
  const Color(0xFF1AFF33),
  const Color(0xFF999933),
  const Color(0xFFFF3380),
  const Color(0xFFCCCC00),
  const Color(0xFF66E64D),
  const Color(0xFF4D80CC),
  const Color(0xFF9900B3),
  const Color(0xFFE64D66),
  const Color(0xFF4DB380),
  const Color(0xFFFF4D4D),
  const Color(0xFF99E6E6),
  const Color(0xFF6666FF)
];

class Helper {
  double roundDouble(double value, int places) {
    double mod = pow(10.0, places) as double;
    return ((value * mod).round().toDouble() / mod);
  }

  String formatMoney(int money) {
    var formatter = NumberFormat('#,###');
    return formatter.format(money);
  }

  Color getItemTypeColor(String type) {
    if (type == 'form.type.cash' || type == 'form.type.cash'.tr) {
      return AppColor.pink;
    }
    if (type == 'form.type.bank' || type == 'form.type.bank'.tr) {
      return Colors.blue;
    }
    if (type == 'form.type.eWallet' || type == 'form.type.eWallet'.tr) {
      return AppColor.gold;
    }
    var listGenre = AppConstantList.listExpenseGenre;
    for (var i = 0; i < listGenre.length; i++) {
      if (type == listGenre[i] || type == listGenre[i].tr) {
        return colorArray[i];
      }
    }
    return AppColor.gold;
  }
}
