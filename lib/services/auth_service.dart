import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AuthService {
  static final LocalAuthentication _auth = LocalAuthentication();

  // Check if the device is capable of biometrics
  static Future<bool> canAuthenticate() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  // The actual authentication logic
  static Future<bool> authenticate(BuildContext context) async {
    try {
      if (!await canAuthenticate()) return false;

      final l10n = AppLocalizations.of(context)!;

      return await _auth.authenticate(
        localizedReason: l10n.authReason,
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