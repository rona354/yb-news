import 'package:flutter/foundation.dart';

class AppConstants {
  static const String appName = 'YB News';
  static const int otpLength = 8;
  static const int otpExpiryMinutes = 3;
  static const int otpResendSeconds = 180;

  static String? get demoEmail => kDebugMode ? 'demo@example.com' : null;
  static String? get demoPassword => kDebugMode ? 'Demo1234' : null;
}
