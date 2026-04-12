import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  // Check if the device is capable of biometrics
  static Future<bool> canAuthenticate() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  // The actual authentication logic
  static Future<bool> authenticate() async {
    try {
      if (!await canAuthenticate()) return false;

      return await _auth.authenticate(
        localizedReason: 'Please authenticate to view your notes',
        options: const AuthenticationOptions(
          stickyAuth: true, // Keeps auth alive if app goes to background
          biometricOnly: true, // Prevents bypass via PIN/Pattern if preferred
          //useErrorDialogs: true
        ),
      );
    } on PlatformException catch (e) {
      print("Auth Error: $e");
      return false;
    }
  }
}