import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_helper_getx_mvc/app/app_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GApi {
  AppController appController = Get.put(AppController());
  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: [
      'https://www.googleapis.com/auth/drive',
    ],
  );

  Future<void> handleSignIn() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      GoogleSignInAccount? userLogin = await googleSignIn.signIn();

      if (userLogin != null) {
        appController.userDisplayName.value = userLogin.displayName.toString();
        appController.userEmail.value = userLogin.email.toString();
        appController.userId.value = userLogin.id.toString();
        appController.userPhotoUrl.value = userLogin.photoUrl.toString();

        prefs.setString('displayName', userLogin.displayName.toString());
        prefs.setString('email', userLogin.email.toString());
        prefs.setString('id', userLogin.id.toString());
        prefs.setString('photoUrl', userLogin.photoUrl.toString());
      }
      // print(googleSignIn.currentUser.displayName);
    } catch (error) {
      rethrow;
    }
  }

  handleSignOut() async {
    googleSignIn.signOut();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    appController.userDisplayName.value = '';
    appController.userEmail.value = '';
    appController.userId.value = '';
    appController.userPhotoUrl.value = '';

    prefs.remove('displayName');
    prefs.remove('email');
    prefs.remove('id');
    prefs.remove('photoUrl');
  }
}
