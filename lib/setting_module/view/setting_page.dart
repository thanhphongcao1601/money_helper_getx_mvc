import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

// ignore: must_be_immutable
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppController appController = Get.find<AppController>();
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    items = appController.listLangue;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(
      () => Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.brown.shade800,
              child: const Text('AH'),
            ),
            title: const Text('Hi, Thanh Phong'),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
              title: Text('setting.darkMode'.tr),
              trailing: Switch(
                value: appController.isDarkMode.value,
                activeColor: Theme.of(context).colorScheme.secondary,
                onChanged: (bool value) {
                  Get.changeTheme(value
                      ? ThemeData.dark()
                      : ThemeData(primarySwatch: Colors.blueGrey));
                  appController.isDarkMode.value = value;
                },
              )),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            title: Text('setting.language'.tr),
            trailing: DropdownButtonHideUnderline(
              child: DropdownButton2(
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                value: appController.currentLanguageCode.value,
                onChanged: (value) {
                  appController.changeLanguage(value.toString());
                },
                buttonHeight: 40,
                buttonWidth: 140,
                itemHeight: 40,
              ),
            ),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            title: Text('setting.updateProfile'.tr),
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
            title: Text('setting.updateProfile'.tr),
            trailing: const Icon(Icons.arrow_right),
          ),
          const Divider(
            thickness: 1,
          ),
        ],
      ),
    ));
  }
}
