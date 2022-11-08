import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/setting_module/view/setting_controller.dart';
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
  final settingController = Get.put(SettingController());
  AppController appController = Get.find<AppController>();

  List<String> items = [];
  final GoogleDriveAppData googleDriveAppData = GoogleDriveAppData();
  GoogleSignInAccount? googleUser;
  drive.DriveApi? driveApi;

  String backUpTime = 'day';

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
              onTap: () {
                Get.bottomSheet(
                  Container(
                      padding: const EdgeInsets.all(10),
                      height: Get.height / 2,
                      color: AppColor.darkPurple,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'setting.backUp.bottomSheet.chooseBackUpTime'.tr,
                            style: const TextStyle(
                                color: AppColor.gold, fontSize: 20),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Obx(() => Checkbox(
                                    checkColor: AppColor.darkPurple,
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => AppColor.gold),
                                    value: settingController
                                        .isAutoBackUpCheckBox.value,
                                    onChanged: (bool? value) {
                                      settingController
                                          .changeIsAutoBackUpCheckBox();
                                    },
                                  )),
                              Text(
                                'setting.backUp.bottomSheet.autoBackUp'.tr,
                                style: const TextStyle(color: AppColor.gold),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Obx(() => Radio(
                                    value: 'day',
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => AppColor.gold),
                                    groupValue:
                                        settingController.backUpType.value,
                                    activeColor: AppColor.gold,
                                    onChanged: (String? value) {
                                      settingController.changeBackUpType('day');
                                    },
                                  )),
                              Text(
                                'setting.backUp.bottomSheet.daily'.tr,
                                style: const TextStyle(color: AppColor.gold),
                              ),
                              const SizedBox(
                                width: 50,
                              ),
                              Obx(() => Radio(
                                    value: 'week',
                                    groupValue:
                                        settingController.backUpType.value,
                                    activeColor: AppColor.gold,
                                    fillColor: MaterialStateColor.resolveWith(
                                        (states) => AppColor.gold), //
                                    onChanged: (String? value) {
                                      settingController
                                          .changeBackUpType('week');
                                    },
                                  )),
                              Text(
                                'setting.backUp.bottomSheet.weekly'.tr,
                                style: const TextStyle(color: AppColor.gold),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(width: 2, color: AppColor.gold)),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'setting.backUp.bottomSheet.time'.tr,
                                    style:
                                        const TextStyle(color: AppColor.gold),
                                  ),
                                  Text(DateTime.now().toString(),
                                      style:
                                          const TextStyle(color: AppColor.gold))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('setting.backUp.bottomSheet.url'.tr,
                                      style: const TextStyle(
                                          color: AppColor.gold)),
                                  const Text('https://drive.google.com',
                                      style: TextStyle(color: AppColor.gold))
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('setting.backUp.bottomSheet.email'.tr,
                                      style: const TextStyle(
                                          color: AppColor.gold)),
                                  Text(appController.userEmail.value,
                                      style:
                                          const TextStyle(color: AppColor.gold))
                                ],
                              )
                            ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              buildCancelButton(),
                              buildBackUpButton(),
                            ],
                          )
                        ],
                      )),
                  // barrierColor: Colors.red[50],
                  // isDismissible: false,
                );
              },
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
            !appController.isLogged.value
                ? SizedBox(
                    width: Get.width / 2,
                    child: OutlinedButton(
                      onPressed: () async {
                        //GApi().handleSignIn();
                        appController.signIn();
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
                        trailing:
                            const Icon(Icons.arrow_right, color: AppColor.gold),
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
          visible: appController.isLogged.value,
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

  Widget buildBackUpButton() {
    return SizedBox(
      width: Get.width / 2 - 20,
      child: ElevatedButton(
        onPressed: () {
          appController.handleBackUp();
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
        child: Text(
          'setting.backUp.bottomSheet.backUp'.tr,
          style: const TextStyle(color: AppColor.darkPurple),
        ),
      ),
    );
  }

  Widget buildCancelButton() {
    return SizedBox(
      width: Get.width / 2 - 20,
      child: OutlinedButton(
        onPressed: () {
          Get.back();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.gold),
        ),
        child: Text('setting.backUp.bottomSheet.cancel'.tr,
            style: const TextStyle(color: AppColor.gold)),
      ),
    );
  }
}
