import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app_controller.dart';

class SettingPage extends StatelessWidget {
  SettingPage({super.key});

  AppController appController = Get.find<AppController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Obx(
      () => Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 20,
              backgroundColor: Colors.brown.shade800,
              child: const Text('AH'),
            ),
            title: Text('Hi, Thanh Phong'),
          ),
          const Divider(
            thickness: 1,
          ),
          ListTile(
              title: const Text('Giao diện tối'),
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
          const ListTile(
            title: Text('Cập nhật tài khoản'),
            trailing: Icon(Icons.arrow_right),
          ),
          const Divider(
            thickness: 1,
          ),
          const ListTile(
            title: Text('Đăng xuất'),
            trailing: Icon(Icons.arrow_right),
          ),
          const Divider(thickness: 1,),
        ],
      ),
    ));
  }
}
