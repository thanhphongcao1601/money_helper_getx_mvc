import 'package:local_auth/local_auth.dart';

class LocalAuth {
  doAuthenticate() async {
    final LocalAuthentication auth = LocalAuthentication();
    print(auth);
    auth.isDeviceSupported().then((bool isSupported) => print(isSupported));
    bool authenticated = await auth.authenticate(
        localizedReason:
            'Scan your fingerprint (or face or whatever) to authenticate');
  }
}
