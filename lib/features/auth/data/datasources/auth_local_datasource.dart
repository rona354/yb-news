import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:yb_news/core/errors/exceptions.dart';
import 'package:yb_news/shared/services/secure_storage_service.dart';

class AuthLocalDatasource {
  static const int _maxLoginAttempts = 5;
  static const int _lockoutDurationMinutes = 15;

  Future<Map<String, dynamic>?> login(String email, String password) async {
    await _checkRateLimit(email);
    await Future.delayed(const Duration(milliseconds: 800));

    final users = await SecureStorageService.getUsers();
    final user = users[email];

    if (user == null) {
      await _recordFailedAttempt(email);
      throw UserNotFoundException();
    }

    final salt = user['salt'] as String?;
    if (user['password'] != _hashPassword(password, salt)) {
      await _recordFailedAttempt(email);
      throw InvalidCredentialsException();
    }

    await _clearLoginAttempts(email);

    if (kDebugMode) {
      debugPrint('[SECURE] Login successful for: $email');
    }
    return user;
  }

  Future<void> _checkRateLimit(String email) async {
    final attempts = await SecureStorageService.getLoginAttempts();
    final userAttempts = attempts[email];

    if (userAttempts == null) return;

    final count = userAttempts['count'] as int? ?? 0;
    final lastAttempt = DateTime.tryParse(userAttempts['lastAttempt'] ?? '');
    final lockedUntil = DateTime.tryParse(userAttempts['lockedUntil'] ?? '');

    if (lockedUntil != null && DateTime.now().isBefore(lockedUntil)) {
      final remaining = lockedUntil.difference(DateTime.now()).inSeconds;
      throw LoginRateLimitedException(remaining);
    }

    if (count >= _maxLoginAttempts && lastAttempt != null) {
      final lockoutEnd = lastAttempt.add(
        Duration(minutes: _lockoutDurationMinutes),
      );
      if (DateTime.now().isBefore(lockoutEnd)) {
        final remaining = lockoutEnd.difference(DateTime.now()).inSeconds;

        attempts[email] = {
          ...userAttempts,
          'lockedUntil': lockoutEnd.toIso8601String(),
        };
        await SecureStorageService.saveLoginAttempts(attempts);

        throw LoginRateLimitedException(remaining);
      } else {
        await _clearLoginAttempts(email);
      }
    }
  }

  Future<void> _recordFailedAttempt(String email) async {
    final attempts = await SecureStorageService.getLoginAttempts();
    final userAttempts = attempts[email] as Map<String, dynamic>? ?? {};

    final currentCount = userAttempts['count'] as int? ?? 0;

    attempts[email] = {
      'count': currentCount + 1,
      'lastAttempt': DateTime.now().toIso8601String(),
    };

    await SecureStorageService.saveLoginAttempts(attempts);

    if (kDebugMode) {
      debugPrint(
        '[SECURE] Failed attempt ${currentCount + 1}/$_maxLoginAttempts for: $email',
      );
    }
  }

  Future<void> _clearLoginAttempts(String email) async {
    final attempts = await SecureStorageService.getLoginAttempts();
    attempts.remove(email);
    await SecureStorageService.saveLoginAttempts(attempts);
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final users = await SecureStorageService.getUsers();

    if (users.containsKey(email)) {
      throw EmailAlreadyExistsException();
    }

    final salt = _generateSalt();
    final userData = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'email': email,
      'salt': salt,
      'password': _hashPassword(password, salt),
      'createdAt': DateTime.now().toIso8601String(),
    };

    users[email] = userData;
    await SecureStorageService.saveUsers(users);

    if (kDebugMode) {
      debugPrint('[SECURE] User registered: $email');
    }

    return userData;
  }

  String _generateSalt() {
    final random = Random.secure();
    final saltBytes = List<int>.generate(32, (_) => random.nextInt(256));
    return base64Encode(saltBytes);
  }

  String _hashPassword(String password, String? salt) {
    final saltedPassword = salt != null ? '$salt$password' : password;
    return sha256.convert(utf8.encode(saltedPassword)).toString();
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final users = await SecureStorageService.getUsers();
    final user = users[email];

    if (user == null) {
      throw UserNotFoundException();
    }

    if (kDebugMode) {
      debugPrint('[SECURE] User found by email: $email');
    }
    return user;
  }
}
