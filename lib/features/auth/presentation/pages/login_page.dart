import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yb_news/core/config/routes.dart';
import 'package:yb_news/core/config/theme.dart';
import 'package:yb_news/core/utils/validators.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_event.dart';
import 'package:yb_news/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$feature - Coming soon'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(AppRoutes.newsList);
          } else if (state is AuthNeedsOtp) {
            if (state.demoOtp != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Demo OTP: ${state.demoOtp}'),
                  duration: const Duration(seconds: 15),
                  backgroundColor: Colors.green,
                ),
              );
            }
            context.go(AppRoutes.otp, extra: state.email);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello',
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.titleActive,
                            height: 1.5, // Figma: 72px / 48px = 1.5
                          ),
                        ),
                        Text(
                          'Again!',
                          style: GoogleFonts.poppins(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryColor,
                            height: 1.5, // Figma: 72px / 48px = 1.5
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Welcome back you've\nbeen missed",
                          style: GoogleFonts.poppins(
                            fontSize: 20, // Figma: 20px
                            color: AppTheme.textSecondary, // Figma: #4E4B66
                            height: 1.5, // Figma: 30px / 20px = 1.5
                          ),
                        ),
                        const SizedBox(height: 32),
                        _buildLabel('Email'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppTheme.titleActive,
                          ),
                          decoration: _buildInputDecoration('Enter your email'),
                          validator: Validators.email,
                        ),
                        const SizedBox(height: 20),
                        _buildLabel('Password'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: AppTheme.titleActive,
                          ),
                          decoration:
                              _buildInputDecoration(
                                'Enter your password',
                              ).copyWith(
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: const Color(0xFFA0A0A0),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                          validator: Validators.password,
                          onFieldSubmitted: (_) => _onLogin(),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    value: _rememberMe,
                                    onChanged: (value) {
                                      setState(() {
                                        _rememberMe = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Remember me ',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppTheme
                                        .textSecondary, // Figma: #4E4B66
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.push(AppRoutes.forgotPassword),
                              child: Text(
                                'Forgot the password ?',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400, // Figma: Regular
                                  color: AppTheme.linkBlue, // Figma: #5890FF
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          height: 50, // Figma: 50px
                          child: ElevatedButton(
                            onPressed: state is AuthLoading ? null : _onLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryColor,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // Figma: 6px
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
                                    'Login',
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Center(
                          child: Text(
                            'or continue with',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppTheme.textSecondary, // Figma: #4E4B66
                            ),
                          ),
                        ),
                        const SizedBox(height: 16), // Figma: 16px spacing
                        SizedBox(
                          width: double.infinity,
                          height: 48, // Figma: 48px
                          child: ElevatedButton.icon(
                            onPressed: () => _showComingSoon('Google sign-in'),
                            icon: Image.network(
                              'https://www.google.com/favicon.ico',
                              width: 24,
                              height: 24,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.g_mobiledata, size: 24),
                            ),
                            label: Text(
                              'Google',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600, // Figma: SemiBold
                                color: const Color(
                                  0xFF667085,
                                ), // Figma button label color
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  AppTheme.secondaryButtonBg, // Figma: #EEF1F4
                              foregroundColor: const Color(0xFF667085),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  6,
                                ), // Figma: 6px
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "don't have an account ? ",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppTheme.textSecondary, // Figma: #4E4B66
                              ),
                            ),
                            GestureDetector(
                              onTap: () => context.go(AppRoutes.register),
                              child: Text(
                                'Sign Up',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight:
                                      FontWeight.w600, // Figma: SemiBold
                                  color:
                                      AppTheme.primaryColor, // Figma: #1877F2
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        if (kDebugMode)
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.amber.shade200),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.info_outline,
                                  size: 20,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Demo Mode: Register first, OTP shown in snackbar',
                                    style: GoogleFonts.poppins(fontSize: 12),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLabel(String text) {
    return RichText(
      text: TextSpan(
        text: text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w400, // Figma: Regular
          color: AppTheme.textSecondary, // Figma: #4E4B66
          height: 1.5, // Figma: 21px / 14px = 1.5
        ),
        children: const [
          TextSpan(
            text: '*',
            style: TextStyle(color: AppTheme.requiredRed), // Figma: #C30053
          ),
        ],
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.poppins(
        fontSize: 16,
        color: const Color(0xFFA0A0A0),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6), // Figma: 6px
        borderSide: const BorderSide(color: AppTheme.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6), // Figma: 6px
        borderSide: const BorderSide(color: AppTheme.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(6), // Figma: 6px
        borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 14,
      ), // Figma: 10px padding
    );
  }
}
