import 'dart:convert';
import 'dart:io' as io;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_helper_getx_mvc/api/google_auth_client.dart';

class GoogleDriveAppData {
  
  Future<GoogleSignInAccount?> signInGoogle() async {
    GoogleSignInAccount? googleUser;
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: [
          drive.DriveApi.driveAppdataScope,
        ],
      );

      googleUser =
          await googleSignIn.signInSilently() ?? await googleSignIn.signIn();
    } catch (e) {
      debugPrint(e.toString());
    }
    return googleUser;
  }

  Future<String?> getFolderId(drive.DriveApi driveApi) async {
    const mimeType = "application/vnd.google-apps.folder";
    String folderName = "MoneyManagerBackUp";

    try {
      final found = await driveApi.files.list(
        q: "mimeType = '$mimeType' and name = '$folderName'",
        $fields: "files(id, name)",
      );
      final files = found.files;
      if (files == null) {
        return null;
      }

      // The folder already exists
      if (files.isNotEmpty) {
        return files.first.id;
      }

      // Create a folder
      var folder = drive.File();
      folder.name = folderName;
      folder.mimeType = mimeType;
      final folderCreation = await driveApi.files.create(folder);
      debugPrint("Folder ID: ${folderCreation.id}");

      return folderCreation.id;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  ///sign out from google
  Future<void> signOut() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  ///get google drive client
  Future<drive.DriveApi?> getDriveApi(GoogleSignInAccount googleUser) async {
    drive.DriveApi? driveApi;
    try {
      Map<String, String> headers = await googleUser.authHeaders;
      GoogleAuthClient client = GoogleAuthClient(headers);
      driveApi = drive.DriveApi(client);
    } catch (e) {
      debugPrint(e.toString());
    }
    return driveApi;
  }

  /// upload file to google drive
  Future<drive.File?> uploadDriveFile({
    required drive.DriveApi driveApi,
    required io.File file,
    String? driveFileId,
  }) async {
    try {
      // final folderId = await getFolderId(driveApi);

      drive.File fileMetadata = drive.File();
      fileMetadata.name = path.basename(file.absolute.path);

      late drive.File response;
      if (driveFileId != null) {
        /// [driveFileId] not null means we want to update existing file
        response = await driveApi.files.update(
          fileMetadata,
          driveFileId,
          uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
        );
      } else {
        /// [driveFileId] is null means we want to create new file
        fileMetadata.parents = ['appDataFolder'];
        // fileMetadata.parents = [folderId!];
        response = await driveApi.files.create(
          fileMetadata,
          uploadMedia: drive.Media(file.openRead(), file.lengthSync()),
        );
      }
      return response;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  /// download file from google drive
  Future<io.File?> restoreDriveFile({
    required drive.DriveApi driveApi,
    required drive.File driveFile,
    required String targetLocalPath,
  }) async {
    try {
      drive.Media media = await driveApi.files.get(driveFile.id!,
          downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

      List<int> dataStore = [];

      await media.stream.forEach((element) {
        dataStore.addAll(element);
      });

      io.File file = io.File(targetLocalPath);
      file.writeAsBytesSync(dataStore);

      return file;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  Future<List<drive.File?>> getListDriveFile(drive.DriveApi driveApi) async {
    try {
      // final folderId = await getFolderId(driveApi);
      drive.FileList fileList = await driveApi.files.list(
          // q: "'$folderId' in parents",
          spaces: 'appDataFolder',
          $fields: 'files(id, name, modifiedTime)');

      List<drive.File>? listFiles = fileList.files;

      for (var i = 0; i < listFiles!.length; i++) {
        print("Id: ${listFiles[i].id} File Name:${listFiles[i].name}");
      }

      return listFiles;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  Future<String> getContentFromDriveFile(
      drive.DriveApi driveApi, drive.File driveFile) async {
    var response = await driveApi.files
        .get(driveFile.id!, downloadOptions: drive.DownloadOptions.fullMedia);
    if (response is! drive.Media) throw Exception("invalid response");
    var content = await utf8.decodeStream(response.stream);
    return content;
  }

  /// get drive file info
  Future<drive.File?> getDriveFile(
      drive.DriveApi driveApi, String filename) async {
    try {
      // final folderId = await getFolderId(driveApi);
      drive.FileList fileList = await driveApi.files.list(
          // q: "'$folderId' in parents",
          spaces: 'appDataFolder',
          $fields: 'files(id, name, modifiedTime)');

      List<drive.File>? files = fileList.files;

      drive.File? driveFile =
          files?.firstWhere((element) => element.name == filename);

      return driveFile;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
}
