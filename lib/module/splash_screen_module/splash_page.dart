import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/app/app_view.dart';
import 'package:money_helper_getx_mvc/module/home_module/controller/home_controller.dart';
import 'package:money_helper_getx_mvc/module/sign_in_module/view/sign_in_page.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final appController = Get.put(AppController());
  final homeController = Get.put(HomeController());

  Future<Widget> loadApp() async {
    appController.init();
    homeController.init();

    var prefs = await SharedPreferences.getInstance();
    var isLock = prefs.getBool('isLockApp') ?? false;
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!isLock) {
      return AppPage();
    }
    return const SignInPage();
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset(
        'assets/images/logo.png',
        color: AppColor.gold,
      ),
      backgroundColor: AppColor.purple,
      showLoader: false,
      loadingText: const Text("Loading...",
          style: TextStyle(
            color: AppColor.gold,
          )),
      futureNavigator: loadApp(),
    );
  }
}
