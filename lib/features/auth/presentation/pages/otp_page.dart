import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yb_news/core/config/routes.dart';
import 'package:yb_news/core/config/theme.dart';
import 'package:yb_news/core/constants/app_constants.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_event.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_state.dart';

class OtpPage extends StatefulWidget {
  final String email;

  const OtpPage({super.key, required this.email});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(
    8,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(8, (_) => FocusNode());
  final List<FocusNode> _keyboardListenerNodes = List.generate(
    8,
    (_) => FocusNode(),
  );
  Timer? _timer;
  int _remainingSeconds = AppConstants.otpResendSeconds;
  bool _canResend = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final node in _keyboardListenerNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _remainingSeconds = AppConstants.otpResendSeconds;
    _canResend = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  String get _otp => _controllers.map((c) => c.text).join();

  bool get _isOtpComplete => _otp.length == 8;

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  void _onOtpChanged(int index, String value) {
    setState(() {
      _errorMessage = null;
    });

    if (value.isNotEmpty && index < 7) {
      _focusNodes[index + 1].requestFocus();
    }

    if (_isOtpComplete) {
      _onVerify();
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onVerify() {
    if (!_isOtpComplete) {
      setState(() {
        _errorMessage = 'Please enter complete 8-digit OTP';
      });
      return;
    }

    context.read<AuthBloc>().add(
      VerifyOtpRequested(email: widget.email, otp: _otp),
    );
  }

  void _onResend() {
    if (_canResend) {
      context.read<AuthBloc>().add(SendOtpRequested(email: widget.email));
      _startTimer();
      for (final controller in _controllers) {
        controller.clear();
      }
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.newsList);
          } else if (state is AuthOtpSent) {
            if (kDebugMode && state.demoOtp != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Demo OTP: ${state.demoOtp}'),
                  duration: const Duration(seconds: 10),
                  backgroundColor: Colors.green,
                ),
              );
            }
          } else if (state is AuthError) {
            setState(() {
              _errorMessage = state.message;
            });
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => context.go(AppRoutes.login),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: AppTheme.textSecondary, // Figma: #4E4B66
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'OTP Verification',
                    style: GoogleFonts.poppins(
                      fontSize: 32, // Figma: 32px
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textSecondary, // Figma: #4E4B66
                      height: 1.5, // Figma: 48px / 32px = 1.5
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter the OTP sent to ${widget.email}',
                    style: GoogleFonts.poppins(
                      fontSize: 16, // Figma: 16px
                      color: AppTheme.textSecondary, // Figma: #4E4B66
                      height: 1.5, // Figma: 24px / 16px = 1.5
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(8, (index) {
                          return SizedBox(
                            width: 40,
                            height: 50,
                            child: KeyboardListener(
                              focusNode: _keyboardListenerNodes[index],
                              onKeyEvent: (event) => _onKeyEvent(index, event),
                              child: TextFormField(
                                controller: _controllers[index],
                                focusNode: _focusNodes[index],
                                textAlign: TextAlign.center,
                                maxLength: 1,
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.characters,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'[A-Za-z0-9]'),
                                  ),
                                  UpperCaseTextFormatter(),
                                ],
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.titleActive,
                                ),
                                decoration: InputDecoration(
                                  counterText: '',
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ), // Figma: 6px
                                    borderSide: BorderSide(
                                      color: _errorMessage != null
                                          ? Colors.red
                                          : AppTheme.inputBorder,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ), // Figma: 6px
                                    borderSide: BorderSide(
                                      color: _errorMessage != null
                                          ? Colors.red
                                          : AppTheme.inputBorder,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                      6,
                                    ), // Figma: 6px
                                    borderSide: const BorderSide(
                                      color: AppTheme.primaryColor,
                                      width: 2,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                ),
                                onChanged: (value) =>
                                    _onOtpChanged(index, value),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        _errorMessage!,
                        style: GoogleFonts.poppins(
                          color: AppTheme.requiredRed, // Figma: #C20052
                          fontSize: 14, // Figma: 14px
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  Center(
                    child: GestureDetector(
                      onTap: _canResend ? _onResend : null,
                      child: Text(
                        _canResend
                            ? 'Resend OTP'
                            : 'Resend OTP in $_formattedTime',
                        style: GoogleFonts.poppins(
                          fontSize: 14, // Figma: 14px
                          height: 1.5, // Figma: 21px / 14px = 1.5
                          color: _canResend
                              ? AppTheme.primaryColor
                              : AppTheme.textSecondary, // Figma: #4E4B66
                          fontWeight: _canResend
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 50, // Figma: 50px
                    child: ElevatedButton(
                      onPressed: state is AuthLoading ? null : _onVerify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6), // Figma: 6px
                        ),
                      ),
                      child: state is AuthLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(
                              'Verify',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (kDebugMode)
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withAlpha(20),
                        borderRadius: BorderRadius.circular(6), // Figma: 6px
                        border: Border.all(
                          color: AppTheme.primaryColor.withAlpha(50),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            size: 20,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Demo Mode: OTP shown in green snackbar above',
                              style: GoogleFonts.poppins(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
