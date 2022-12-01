import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/module/setting_module/setting_controller.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:money_helper_getx_mvc/api/google_drive_app_data.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:money_helper_getx_mvc/ultis/widgets/app_dialog.dart';

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
    settingController.init();
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
              onTap: () {
                showLanguageDialog();
              },
              title: Text('setting.language'.tr, style: const TextStyle(color: AppColor.gold)),
              trailing: const Icon(Icons.arrow_right, color: AppColor.gold),
            ),
            const Divider(
              thickness: 1,
            ),
            ListTile(
              onTap: () {
                Get.bottomSheet(buildBackUpBottomSheet()
                    // barrierColor: Colors.red[50],
                    // isDismissible: false,
                    );
              },
              title: Text('setting.backUp'.tr, style: const TextStyle(color: AppColor.gold)),
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
                        appController.signIn();
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColor.gold),
                      ),
                      child: Text('setting.signIn'.tr, style: const TextStyle(color: AppColor.gold)),
                    ))
                : Column(
                    children: [
                      ListTile(
                        onTap: () {
                          handleSignOut();
                        },
                        title: Text('setting.signOut'.tr, style: const TextStyle(color: AppColor.gold)),
                        trailing: const Icon(Icons.arrow_right, color: AppColor.gold),
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

  void handleSignOut() {
    Widget content = Text(
      "setting.signOut.dialog.title.content".tr,
      style: const TextStyle(color: Colors.white),
    );
    backUpBeforeSignOut() async {
      await appController.handleBackUp(isRestore: false);
      await appController.signOut();
    }

    showAppDialog(
        title: 'setting.signOut.dialog.title'.tr,
        content: content,
        onConfirm: () {
          backUpBeforeSignOut();
        },
        onCancel: () {
          appController.signOut();
        },
        confirmText: 'setting.signOut.dialog.confirmText'.tr,
        cancelText: 'setting.signOut.dialog.cancelText'.tr);
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CachedNetworkImage(
                        imageUrl: appController.userPhotoUrl.value,
                        imageBuilder: (context, imageProvider) => Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                          ),
                        ),
                        placeholder: (context, url) => const CircularProgressIndicator(),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(appController.userDisplayName.value,
                              style: const TextStyle(fontSize: 20, color: AppColor.gold)),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            appController.userEmail.value,
                            style: const TextStyle(fontSize: 16, color: AppColor.gold),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Widget buildBackUpBottomSheet() {
    return Container(
        padding: const EdgeInsets.all(10),
        height: 300,
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
              style: const TextStyle(color: AppColor.gold, fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: appController.isLogged.value,
              child: Row(
                children: [
                  Obx(() => Checkbox(
                        checkColor: AppColor.darkPurple,
                        fillColor: MaterialStateColor.resolveWith((states) => AppColor.gold),
                        value: settingController.isAutoBackUpCheckBox.value,
                        onChanged: (bool? value) {
                          settingController.changeIsAutoBackUpCheckBox(value!);
                        },
                      )),
                  Text(
                    'setting.backUp.bottomSheet.autoBackUp'.tr,
                    style: const TextStyle(color: AppColor.white),
                  ),
                ],
              ),
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.start,
            //   children: [
            //     Obx(() => Radio(
            //           value: 'day',
            //           fillColor: MaterialStateColor.resolveWith(
            //               (states) => AppColor.gold),
            //           groupValue: settingController.backUpType.value,
            //           activeColor: AppColor.gold,
            //           onChanged: (String? value) {
            //             settingController.changeBackUpType('day');
            //           },
            //         )),
            //     Text(
            //       'setting.backUp.bottomSheet.daily'.tr,
            //       style: const TextStyle(color: AppColor.white),
            //     ),
            //     const SizedBox(
            //       width: 50,
            //     ),
            //     Obx(() => Radio(
            //           value: 'week',
            //           groupValue: settingController.backUpType.value,
            //           activeColor: AppColor.gold,
            //           fillColor: MaterialStateColor.resolveWith(
            //               (states) => AppColor.gold), //
            //           onChanged: (String? value) {
            //             settingController.changeBackUpType('week');
            //           },
            //         )),
            //     Text(
            //       'setting.backUp.bottomSheet.weekly'.tr,
            //       style: const TextStyle(color: AppColor.white),
            //     ),
            //   ],
            // ),
            const SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), border: Border.all(width: 2, color: AppColor.gold)),
              child: Column(children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'setting.backUp.bottomSheet.time'.tr,
                      style: const TextStyle(color: AppColor.gold),
                    ),
                    Text(DateTime.now().toString().substring(0, 19), style: const TextStyle(color: AppColor.white))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('setting.backUp.bottomSheet.url'.tr, style: const TextStyle(color: AppColor.gold)),
                    const Text('https://drive.google.com', style: TextStyle(color: AppColor.white))
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('setting.backUp.bottomSheet.email'.tr, style: const TextStyle(color: AppColor.gold)),
                    Text(appController.userEmail.value, style: const TextStyle(color: AppColor.gold))
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
                buildRestoreButton(),
                buildBackUpButton(),
              ],
            )
          ],
        ));
  }

  Widget buildBackUpButton() {
    return SizedBox(
      width: Get.width / 2 - 20,
      child: ElevatedButton(
        onPressed: () {
          appController.handleBackUp(isRestore: true);
        },
        style: ElevatedButton.styleFrom(backgroundColor: AppColor.gold),
        child: Text(
          'setting.backUp.bottomSheet.backUp'.tr,
          style: const TextStyle(color: AppColor.darkPurple),
        ),
      ),
    );
  }

  Widget buildRestoreButton() {
    return SizedBox(
      width: Get.width / 2 - 20,
      child: OutlinedButton(
        onPressed: () {
          showRestoreDialog();
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColor.gold),
        ),
        child: Text('setting.backUp.bottomSheet.restore'.tr, style: const TextStyle(color: AppColor.gold)),
      ),
    );
  }

  showRestoreDialog() {
    Widget content = appController.listBackUpFile.isNotEmpty
        ? SizedBox(
            width: Get.width,
            height: Get.height / 3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (var file in appController.listBackUpFile)
                    ListTile(
                      leading: const Icon(
                        Icons.file_copy,
                        color: Colors.white,
                      ),
                      onTap: () {
                        appController.handleRestore(file.name!);
                      },
                      title: Text(
                        file!.name!.substring(0, file.name!.length - 11),
                        style: const TextStyle(color: Colors.white),
                      ),
                    )
                ],
              ),
            ),
          )
        : Lottie.asset('assets/lotties/empty.json', width: 100);
    showAppDialog(title: 'setting.backUp.bottomSheet.dialog.chooseFile'.tr, content: content);
  }

  showLanguageDialog() {
    Widget content = Column(
      children: [
        for (var item in appController.listMapLanguageAndCode.entries)
          InkWell(
            onTap: () {
              appController.changeLanguage(item.value);
            },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10, top: 10),
              child: Text(
                item.key,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          )
      ],
    );
    showAppDialog(title: 'setting.language'.tr, content: content);
  }
}
