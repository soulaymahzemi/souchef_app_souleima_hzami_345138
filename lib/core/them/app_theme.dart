import 'package:flutter/material.dart';
import 'package:esame/core/them/color.dart';
import 'package:esame/core/them/text_style.dart';

class AppTheme {

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: primary,
      scaffoldBackgroundColor: white,
      colorScheme: const ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: white,
        background: background,
        error: red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: white,
        foregroundColor: black,
        elevation: 0,
        titleTextStyle: appBarTextStyle,
        iconTheme: const IconThemeData(color: black),
      ),
      cardTheme: CardTheme(
        color: white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      iconTheme: const IconThemeData(color: black),
      textTheme: TextTheme(
        displayLarge: titleTextStyle,
        displayMedium: subTitleTextStyle,
        bodyLarge: bodyTextStyle,
        bodyMedium: bodyTextStyle,
        titleMedium: subTitleTextStyle,
        labelLarge: buttonTextStyle,
      ),

    );
  }
}
