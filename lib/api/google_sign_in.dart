// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/drive/v3.dart';
// import 'package:money_helper_getx_mvc/api/google_auth_client.dart';
// import 'package:money_helper_getx_mvc/app/app_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class GApi {
//   GoogleSignInAccount? account;
//   AppController appController = Get.put(AppController());
//   GoogleSignIn googleSignIn = GoogleSignIn(
//     scopes: [
//       'https://www.googleapis.com/auth/drive',
//     ],
//   );

//   Future<GoogleSignInAccount?> handleSignIn() async {
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       account = await googleSignIn.signIn();

//       if (account != null) {
//         appController.userDisplayName.value = account!.displayName.toString();
//         appController.userEmail.value = account!.email.toString();
//         appController.userId.value = account!.id.toString();
//         appController.userPhotoUrl.value = account!.photoUrl.toString();

//         prefs.setString('displayName', account!.displayName.toString());
//         prefs.setString('email', account!.email.toString());
//         prefs.setString('id', account!.id.toString());
//         prefs.setString('photoUrl', account!.photoUrl.toString());

//         return account;
//       }
//     } catch (error) {
//       rethrow;
//     }
//     return null;
//   }

//   handleSaveFileToDrive() async {
//     account ??= await googleSignIn.signIn();
//     if (account != null) {
//       final authHeaders = await account!.authHeaders;
//       final authenticateClient = GoogleAuthClient(authHeaders);
//       final driveApi = DriveApi(authenticateClient);

//       final Stream<List<int>> mediaStream = Future.value([104, 105]).asStream();
//       var media = Media(mediaStream, 2);
//       var driveFile = File();

//       driveFile.name = "money_manager_backup.txt";

//       final result = await driveApi.files.create(driveFile, uploadMedia: media);
//       print("Upload result: $result");
//     }
//   }

//   handleSignOut() async {
//     googleSignIn.signOut();

//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     appController.userDisplayName.value = '';
//     appController.userEmail.value = '';
//     appController.userId.value = '';
//     appController.userPhotoUrl.value = '';

//     prefs.remove('displayName');
//     prefs.remove('email');
//     prefs.remove('id');
//     prefs.remove('photoUrl');
//   }
// }
