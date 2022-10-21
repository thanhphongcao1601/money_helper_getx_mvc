// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

Widget ItemSelect(
    String genreName, TextEditingController controller, Function function) {
  return InkWell(
    child: InkWell(
      onTap: () {
        function();
        controller.text = genreName;
      },
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          border: Border.all(width: 2),
          borderRadius: BorderRadius.circular(5),
          // color: const Color(AppColor.pink),
        ),
        alignment: Alignment.center,
        child: Text(genreName),
      ),
    ),
  );
}
