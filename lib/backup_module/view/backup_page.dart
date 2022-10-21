import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BackUpPage extends StatelessWidget {
  const BackUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        InkWell(
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<String> listStringRecord =
                prefs.getStringList('listRecord') ?? [];
            print(listStringRecord.length);
            listStringRecord.forEach((element) {
              print(element);
            });
          },
          child: const ListTile(
            title: Text('Sao luu'),
          ),
        )
      ],
    ));
  }
}
