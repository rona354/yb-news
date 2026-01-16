import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:yb_news/core/errors/exceptions.dart';

class OtpData {
  final String otp;
  final DateTime expiry;

  OtpData({required this.otp, required this.expiry});
}

class OtpResult {
  final bool success;
  final String? otp;
  final DateTime? expiry;
  final bool isDemo;
  final int? retryAfterSeconds;

  OtpResult({
    required this.success,
    this.otp,
    this.expiry,
    this.isDemo = false,
    this.retryAfterSeconds,
  });
}

class OtpService {
  static final Map<String, OtpData> _otpStore = {};
  static final Map<String, DateTime> _lastOtpRequest = {};
  static const int _minResendIntervalSeconds = 60;

  static String _generateOtp() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random.secure();
    return List.generate(8, (_) => chars[random.nextInt(chars.length)]).join();
  }

  static Future<OtpResult> sendOtp(String email) async {
    final lastRequest = _lastOtpRequest[email];
    if (lastRequest != null) {
      final elapsed = DateTime.now().difference(lastRequest).inSeconds;
      if (elapsed < _minResendIntervalSeconds) {
        final retryAfter = _minResendIntervalSeconds - elapsed;
        throw OtpRateLimitedException(retryAfter);
      }
    }

    final otp = _generateOtp();
    final expiry = DateTime.now().add(const Duration(minutes: 3));

    _otpStore[email] = OtpData(otp: otp, expiry: expiry);
    _lastOtpRequest[email] = DateTime.now();

    await Future.delayed(const Duration(milliseconds: 800));

    if (kDebugMode) {
      debugPrint('═══════════════════════════════════════');
      debugPrint('DEMO MODE - OTP GENERATED');
      debugPrint('Email: $email');
      debugPrint('OTP: $otp');
      debugPrint('Expires: $expiry');
      debugPrint('═══════════════════════════════════════');
    }

    return OtpResult(success: true, otp: otp, expiry: expiry, isDemo: true);
  }

  static Future<bool> verifyOtp(String email, String inputOtp) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final stored = _otpStore[email];
    if (stored == null) return false;

    if (DateTime.now().isAfter(stored.expiry)) {
      _otpStore.remove(email);
      throw OtpExpiredException();
    }

    if (stored.otp != inputOtp.toUpperCase()) {
      return false;
    }

    _otpStore.remove(email);
    return true;
  }
}
