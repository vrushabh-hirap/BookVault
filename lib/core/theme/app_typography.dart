import 'package:flutter/material.dart';

/// App-wide typography utilizing Apple's SF Serif for a premium, minimal look
/// We use fallback fonts to ensure it renders correctly on macOS.
class AppTypography {
  static const String fontFamily = 'SF Serif'; // Conceptual name
  static const List<String> fontFamilyFallback = ['.AppleSystemUIFontSerif', 'New York', 'serif'];
  
  static const TextTheme textTheme = TextTheme(
    displayLarge: TextStyle(fontFamily: fontFamily, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    displayMedium: TextStyle(fontFamily: fontFamily, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
    displaySmall: TextStyle(fontFamily: fontFamily, fontSize: 24, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(fontFamily: fontFamily, fontSize: 22, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(fontFamily: fontFamily, fontSize: 18, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: fontFamily, fontSize: 16, fontWeight: FontWeight.normal),
    bodyMedium: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.normal),
    bodySmall: TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.normal),
    labelLarge: TextStyle(fontFamily: fontFamily, fontSize: 14, fontWeight: FontWeight.w500),
    labelMedium: TextStyle(fontFamily: fontFamily, fontSize: 12, fontWeight: FontWeight.w500),
    labelSmall: TextStyle(fontFamily: fontFamily, fontSize: 10, fontWeight: FontWeight.w500),
  );
}
