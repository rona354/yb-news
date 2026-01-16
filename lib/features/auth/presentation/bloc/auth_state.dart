import 'package:equatable/equatable.dart';
import 'package:yb_news/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthNeedsOtp extends AuthState {
  final String email;
  final String? demoOtp;

  const AuthNeedsOtp({required this.email, this.demoOtp});

  @override
  List<Object?> get props => [email, demoOtp];
}

class AuthOtpSent extends AuthState {
  final String email;
  final String? demoOtp;

  const AuthOtpSent({required this.email, this.demoOtp});

  @override
  List<Object?> get props => [email, demoOtp];
}

class AuthAuthenticated extends AuthState {
  final User user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object?> get props => [user];
}

class AuthRegistered extends AuthState {
  final String email;

  const AuthRegistered({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}
