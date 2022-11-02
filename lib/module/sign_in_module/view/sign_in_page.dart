import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:money_helper_getx_mvc/app/app_view.dart';
import 'package:money_helper_getx_mvc/service/auth/local_auth.dart';
import 'package:money_helper_getx_mvc/ultis/constants/constant.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  AppController appController = Get.put(AppController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.purple,
        child: Center(
            child: Column(
          children: [
            Expanded(
                child: SizedBox(
                    width: 100,
                    child: Image.asset(
                      'assets/images/logo.png',
                      color: AppColor.gold,
                    ))),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: InkWell(
                onTap: () async {
                  bool pass = await LocalAuth().doAuthenticate();
                  if (pass) {
                    Get.to(() => AppPage());
                  }
                },
                child: const FaIcon(
                  FontAwesomeIcons.fingerprint,
                  size: 50,
                  color: AppColor.gold,
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
