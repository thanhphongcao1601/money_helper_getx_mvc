import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:money_helper_getx_mvc/api/google_sign_in.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/backup_module/view/backup_page.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/api/google_drive_app_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;

// ignore: must_be_immutable
class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  AppController appController = Get.find<AppController>();
  List<String> items = [];
  final GoogleDriveAppData googleDriveAppData = GoogleDriveAppData();
  GoogleSignInAccount? googleUser;
  drive.DriveApi? driveApi;

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
            buildHeader(),
            ListTile(
                title: Text(
                  'setting.lockAppBiometrics'.tr,
                  style: const TextStyle(color: AppColor.gold),
                ),
                trailing: Switch(
                  value: appController.isLockApp.value,
                  activeColor: AppColor.gold,
                  onChanged: (bool value) {
                    appController.handleToggleLockApp(value);
                  },
                )),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              title: Text('setting.language'.tr,
                  style: const TextStyle(color: AppColor.gold)),
              trailing: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  items: items
                      .map((item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item,
                                style: const TextStyle(color: AppColor.gold)),
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
              onTap: () => Get.to(() => BackUpPage()),
              title: Text('setting.backUp'.tr,
                  style: const TextStyle(color: AppColor.gold)),
              trailing: const Icon(
                Icons.arrow_right,
                color: AppColor.gold,
              ),
            ),
            const Divider(
              thickness: 1,
            ),
            appController.userId.value == ''
                ? SizedBox(
                    width: Get.width / 2,
                    child: OutlinedButton(
                      onPressed: () async {
                        //GApi().handleSignIn();
                        if (googleUser == null) {
                          googleUser = await googleDriveAppData.signInGoogle();
                          if (googleUser != null) {
                            driveApi = await googleDriveAppData
                                .getDriveApi(googleUser!);
                          }
                        } else {}
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColor.gold),
                      ),
                      child: Text('setting.signIn'.tr,
                          style: const TextStyle(color: AppColor.gold)),
                    ))
                : Column(
                    children: [
                      ListTile(
                        onTap: () async {
                          appController.signOut();
                        },
                        title: Text('setting.signOut'.tr,
                            style: const TextStyle(color: AppColor.gold)),
                        trailing: const Icon(Icons.arrow_right),
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                    ],
                  ),
          ],
        ),
      )),
    );
  }

  Widget buildHeader() {
    return Obx(() => Visibility(
          visible: appController.userId.value != '',
          child: Container(
            color: AppColor.darkPurple,
            child: Padding(
              padding: const EdgeInsets.all(10),
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
                        children: [
                          Text(appController.userDisplayName.value,
                              style: const TextStyle(
                                  fontSize: 20, color: AppColor.gold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            appController.userEmail.value,
                            style: const TextStyle(
                                fontSize: 16, color: AppColor.gold),
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: NetworkImage(appController
                                .userPhotoUrl.value.isNotEmpty
                            ? appController.userPhotoUrl.value
                            : 'https://daknong.dms.gov.vn/CmsView-QLTT-portlet/res/no-image.jpg'),
                        radius: 25,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
