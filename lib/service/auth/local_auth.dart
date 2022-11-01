import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuth {
  Future<bool> doAuthenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();
    if (canAuthenticate) {
      try {
        final bool didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate to open app');
        return didAuthenticate;
      } on PlatformException {
        return false;
      }
    }
    return false;
  }
}
