class UserNotFoundException implements Exception {
  final String message;
  UserNotFoundException([this.message = 'User not found']);
}

class InvalidCredentialsException implements Exception {
  final String message;
  InvalidCredentialsException([this.message = 'Invalid credentials']);
}

class EmailAlreadyExistsException implements Exception {
  final String message;
  EmailAlreadyExistsException([this.message = 'Email already exists']);
}

class OtpExpiredException implements Exception {
  final String message;
  OtpExpiredException([this.message = 'OTP expired, please request a new one']);
}

class OtpRateLimitedException implements Exception {
  final int retryAfterSeconds;
  OtpRateLimitedException(this.retryAfterSeconds);
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'Network error occurred']);
}

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  ApiException(this.message, [this.statusCode]);
}

class LoginRateLimitedException implements Exception {
  final int retryAfterSeconds;
  LoginRateLimitedException(this.retryAfterSeconds);
}

class SessionExpiredException implements Exception {
  final String message;
  SessionExpiredException([
    this.message = 'Session expired, please login again',
  ]);
}
