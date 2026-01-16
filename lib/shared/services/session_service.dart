import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:yb_news/shared/services/secure_storage_service.dart';

class SessionService {
  static const _loginHistoryKey = 'login_history';
  static const int _sessionDurationHours = 24;

  static Future<String> createSession(String userId) async {
    final sessionToken = const Uuid().v4();
    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: _sessionDurationHours));

    final sessionData = {
      'userId': userId,
      'token': sessionToken,
      'createdAt': now.toIso8601String(),
      'expiresAt': expiresAt.toIso8601String(),
      'device': 'device_${now.millisecondsSinceEpoch}',
    };

    await SecureStorageService.saveSession(sessionData);
    await SecureStorageService.setActiveSession(userId, sessionToken);

    if (kDebugMode) {
      debugPrint('[SECURE] Session created, expires: $expiresAt');
      debugPrint('[SECURE] Previous sessions for this user invalidated');
    }

    return sessionToken;
  }

  static Future<bool> validateSession() async {
    final session = await SecureStorageService.getSession();

    if (session == null) return false;

    final expiresAt = DateTime.tryParse(session['expiresAt'] ?? '');
    if (expiresAt == null) return false;

    if (DateTime.now().isAfter(expiresAt)) {
      await clearSession();
      if (kDebugMode) {
        debugPrint('[SECURE] Session expired, cleared');
      }
      return false;
    }

    final userId = session['userId'] as String?;
    final token = session['token'] as String?;
    if (userId == null || token == null) return false;

    final activeToken = await SecureStorageService.getActiveSessionToken(userId);
    if (activeToken != token) {
      await clearSession();
      if (kDebugMode) {
        debugPrint('[SECURE] Session invalidated: logged in from another device');
      }
      return false;
    }

    return true;
  }

  static Future<String?> getSessionToken() async {
    final session = await SecureStorageService.getSession();
    return session?['token'] as String?;
  }

  static Future<String?> getSessionUserId() async {
    final session = await SecureStorageService.getSession();
    return session?['userId'] as String?;
  }

  static Future<bool> isFirstTimeLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_loginHistoryKey) ?? [];

    return !history.contains(email);
  }

  static Future<void> recordLogin(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final history = prefs.getStringList(_loginHistoryKey) ?? [];

    if (!history.contains(email)) {
      history.add(email);
      await prefs.setStringList(_loginHistoryKey, history);
    }
  }

  static Future<void> clearSession() async {
    final session = await SecureStorageService.getSession();
    if (session != null) {
      final userId = session['userId'] as String?;
      if (userId != null) {
        await SecureStorageService.clearActiveSession(userId);
      }
    }
    await SecureStorageService.clearSession();
  }

  static Future<void> refreshSession() async {
    final session = await SecureStorageService.getSession();
    if (session == null) return;

    final now = DateTime.now();
    final expiresAt = now.add(const Duration(hours: _sessionDurationHours));

    session['expiresAt'] = expiresAt.toIso8601String();
    await SecureStorageService.saveSession(session);

    if (kDebugMode) {
      debugPrint('[SECURE] Session refreshed, new expiry: $expiresAt');
    }
  }
}
