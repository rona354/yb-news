import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const _usersKey = 'secure_users';
  static const _sessionKey = 'secure_session';
  static const _loginAttemptsKey = 'login_attempts';
  static const _activeSessionsKey = 'active_sessions';

  static Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  static Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  static Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  static Future<Map<String, dynamic>> getUsers() async {
    final data = await read(_usersKey);
    if (data == null) return {};
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  static Future<void> saveUsers(Map<String, dynamic> users) async {
    await write(_usersKey, jsonEncode(users));
  }

  static Future<Map<String, dynamic>?> getSession() async {
    final data = await read(_sessionKey);
    if (data == null) return null;
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  static Future<void> saveSession(Map<String, dynamic> session) async {
    await write(_sessionKey, jsonEncode(session));
  }

  static Future<void> clearSession() async {
    await delete(_sessionKey);
  }

  static Future<Map<String, dynamic>> getLoginAttempts() async {
    final data = await read(_loginAttemptsKey);
    if (data == null) return {};
    return Map<String, dynamic>.from(jsonDecode(data));
  }

  static Future<void> saveLoginAttempts(Map<String, dynamic> attempts) async {
    await write(_loginAttemptsKey, jsonEncode(attempts));
  }

  static Future<Map<String, String>> getActiveSessions() async {
    final data = await read(_activeSessionsKey);
    if (data == null) return {};
    return Map<String, String>.from(jsonDecode(data));
  }

  static Future<void> setActiveSession(String userId, String sessionToken) async {
    final sessions = await getActiveSessions();
    sessions[userId] = sessionToken;
    await write(_activeSessionsKey, jsonEncode(sessions));
  }

  static Future<String?> getActiveSessionToken(String userId) async {
    final sessions = await getActiveSessions();
    return sessions[userId];
  }

  static Future<void> clearActiveSession(String userId) async {
    final sessions = await getActiveSessions();
    sessions.remove(userId);
    await write(_activeSessionsKey, jsonEncode(sessions));
  }
}
