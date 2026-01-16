import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yb_news/core/errors/exceptions.dart';
import 'package:yb_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_event.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_state.dart';
import 'package:yb_news/shared/services/otp_service.dart';
import 'package:yb_news/shared/services/session_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _repository;

  AuthBloc({required AuthRepository repository})
    : _repository = repository,
      super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<SendOtpRequested>(_onSendOtpRequested);
    on<VerifyOtpRequested>(_onVerifyOtpRequested);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(event.email, event.password);

      final isFirstTime = await SessionService.isFirstTimeLogin(event.email);
      if (isFirstTime) {
        final otpResult = await OtpService.sendOtp(event.email);
        emit(AuthNeedsOtp(email: event.email, demoOtp: otpResult.otp));
      } else {
        await SessionService.createSession(user.id);
        emit(AuthAuthenticated(user: user));
      }
    } on LoginRateLimitedException catch (e) {
      final minutes = (e.retryAfterSeconds / 60).ceil();
      emit(
        AuthError(
          message:
              'Too many login attempts. Try again in $minutes minute${minutes > 1 ? 's' : ''}.',
        ),
      );
    } on UserNotFoundException {
      emit(const AuthError(message: 'User not found'));
    } on InvalidCredentialsException {
      emit(const AuthError(message: 'Invalid email or password'));
    } on OtpRateLimitedException catch (e) {
      emit(
        AuthError(
          message:
              'Please wait ${e.retryAfterSeconds}s before requesting a new OTP',
        ),
      );
    } catch (e) {
      emit(AuthError(message: 'Login failed: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repository.register(
        name: event.name,
        email: event.email,
        password: event.password,
      );
      emit(AuthRegistered(email: event.email));
    } on EmailAlreadyExistsException {
      emit(const AuthError(message: 'Email already registered'));
    } catch (e) {
      emit(AuthError(message: 'Registration failed: ${e.toString()}'));
    }
  }

  Future<void> _onSendOtpRequested(
    SendOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final otpResult = await OtpService.sendOtp(event.email);
      emit(AuthOtpSent(email: event.email, demoOtp: otpResult.otp));
    } on OtpRateLimitedException catch (e) {
      emit(
        AuthError(
          message:
              'Please wait ${e.retryAfterSeconds}s before requesting a new OTP',
        ),
      );
    } catch (e) {
      emit(AuthError(message: 'Failed to send OTP: ${e.toString()}'));
    }
  }

  Future<void> _onVerifyOtpRequested(
    VerifyOtpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final isValid = await OtpService.verifyOtp(event.email, event.otp);
      if (isValid) {
        final user = await _repository.getUserByEmail(event.email);
        await SessionService.recordLogin(event.email);
        await SessionService.createSession(user.id);
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Invalid OTP'));
      }
    } on OtpExpiredException {
      emit(const AuthError(message: 'OTP expired, please request a new one'));
    } on UserNotFoundException {
      emit(const AuthError(message: 'User not found'));
    } catch (e) {
      emit(AuthError(message: 'OTP verification failed: ${e.toString()}'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await SessionService.clearSession();
    emit(AuthInitial());
  }
}
