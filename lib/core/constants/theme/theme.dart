import 'package:flutter/material.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';

// Глобальная тема приложения
final globalTheme = ThemeData(
  // fontFamily: GoogleFonts.roboto().fontFamily,
  fontFamily: 'Roboto',
  dividerColor: Colors.transparent,
  expansionTileTheme: const ExpansionTileThemeData(
    textColor: Colors.black87,
    collapsedIconColor: AppColors.primaryColor,
    iconColor: AppColors.primaryColor,
    // collapsedBackgroundColor: Colors.transparent,
  ),
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.primaryColor),
  scaffoldBackgroundColor: AppColors.primaryBackground,
  bottomAppBarTheme: const BottomAppBarTheme(
    color: Colors.white,
    shape: CircularNotchedRectangle(),
  ),
  appBarTheme: const AppBarTheme(
    color: Colors.transparent,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.textLightColor,
  ),
  primaryIconTheme: const IconThemeData(color: Colors.white),
);
