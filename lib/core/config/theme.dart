import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Figma Design Tokens
  static const Color primaryColor = Color(0xFF1877F2);
  static const Color secondaryColor = Color(0xFF26A69A);
  static const Color errorColor = Color(0xFFE53935);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;

  // Text Colors (from Figma)
  static const Color titleActive = Color(0xFF050505);
  static const Color textPrimary = Color(0xFF050505);
  static const Color textSecondary = Color(0xFF4E4B66);

  // Accent Colors (from Figma)
  static const Color requiredRed = Color(0xFFC30053);
  static const Color linkBlue = Color(0xFF5890FF);
  static const Color secondaryButtonBg = Color(0xFFEEF1F4);
  static const Color inputBorder = Color(0xFF4E4B66);
  static const Color onlineGreen = Color(0xFF007D04);

  static TextTheme get _textTheme {
    return GoogleFonts.poppinsTextTheme();
  }

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      textTheme: _textTheme,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: secondaryColor,
        error: errorColor,
        surface: surfaceColor,
      ),
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50), // Figma: 50px
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Figma: 6px
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size(double.infinity, 48), // Figma: 48px
          side: const BorderSide(color: inputBorder),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6), // Figma: 6px
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), // Figma: 6px
          borderSide: const BorderSide(color: inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), // Figma: 6px
          borderSide: const BorderSide(color: inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), // Figma: 6px
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6), // Figma: 6px
          borderSide: const BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 14,
        ), // Figma: 10px padding
        labelStyle: GoogleFonts.poppins(color: textSecondary),
        hintStyle: GoogleFonts.poppins(color: const Color(0xFFA0A0A0)),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.grey.shade200,
        selectedColor: primaryColor.withAlpha(51),
        labelStyle: GoogleFonts.poppins(color: textPrimary),
        secondaryLabelStyle: GoogleFonts.poppins(color: Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return primaryColor;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3), // Figma: 3px
        ),
        side: const BorderSide(color: inputBorder, width: 2), // Figma: 2px
      ),
    );
  }
}
