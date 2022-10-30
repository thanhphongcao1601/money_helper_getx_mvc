import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

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
    return SizedBox(
      height: Get.height,
      child: SingleChildScrollView(
          child: Obx(
        () => Column(
          children: [
            buildHeader(context),
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
      )),
    );
  }

  Widget buildHeader(BuildContext context) {
    return Container(
      color: AppColor.darkPurple,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hi,',
                      style: TextStyle(fontSize: 20, color: AppColor.gold),
                    ),
                    Text('Human',
                        style: TextStyle(fontSize: 28, color: AppColor.gold)),
                  ],
                ),
                const SizedBox(
                  width: 10,
                ),
                const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/dashboardbg.jpg'),
                  radius: 30,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
