import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/app/app_view.dart';
import 'package:money_helper_getx_mvc/module/sign_in_module/view/sign_in_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final appController = Get.put(AppController());

  Future<Widget> loadApp() async {
    appController.init();
    var prefs = await SharedPreferences.getInstance();
      var isLock = prefs.getBool('isLockApp') ?? false;
      if (!isLock) {
        return AppPage();
      }
    return const SignInPage();
  }


  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.network(
          'https://cdn4.iconfinder.com/data/icons/logos-brands-5/24/flutter-512.png'),
      title: const Text(
        "Title",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey.shade400,
      showLoader: true,
      loadingText: const Text("Loading..."),
      durationInSeconds: 5,
      futureNavigator: loadApp(),
    );
  }
}