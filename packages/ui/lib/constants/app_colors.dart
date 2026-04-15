import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Colors
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF818CF8);

  // Secondary Colors
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryDark = Color(0xFF059669);
  static const Color secondaryLight = Color(0xFF34D399);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF6B7280);
  static const Color greyLight = Color(0xFFE5E7EB);
  static const Color greyDark = Color(0xFF374151);

  // Background Colors
  static const Color background = Color(0xFFF9FAFB);
  static const Color surface = Color(0xFFFFFFFF);

  // Status Colors
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimary = Color(0xFF111827);
  static const Color redColor = Colors.red;
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color ruhPrimaryColor = Color(0xFF8B0000);
  static const Color textHint = Color(0xFF9CA3AF);
  static const primaryGradient =  LinearGradient(
      colors: [
        Color.fromARGB(255, 215, 86, 86),
        ruhPrimaryColor,
      ],
      // begin: FractionalOffset(0.0, 0.0),
      // end: FractionalOffset(0.9, 0.0),
      stops: [
        0.0,
        1.0
      ],
      tileMode: TileMode.clamp);
}