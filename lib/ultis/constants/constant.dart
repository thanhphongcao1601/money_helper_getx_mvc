import 'package:flutter/material.dart';

class AppColor {
  static const Color darkPurple = Color(0xff312C51);
  static const Color purple = Color(0xff48426D);
  static const Color gold = Color(0xffF0C38E);
  static const Color pink = Color(0xffF1AA9B);

  static const Color mustHave = Colors.green;
  static const Color niceToHave = Colors.orange;
  static const Color wasted = Colors.redAccent;
}

class AppConstantList {
  static const List<String> listIncomeType = [
    "form.type.cash",
    "form.type.bank",
    "form.type.eWallet",
  ];
  static const List<String> listExpenseGenre = [
    'form.genre.mustHave',
    'form.genre.niceToHave',
    'form.genre.wasted',
  ];
}
