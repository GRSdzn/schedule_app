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
    collapsedBackgroundColor: Colors.transparent,
  ),
  progressIndicatorTheme:
      const ProgressIndicatorThemeData(color: AppColors.primaryColor),
  scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
  primaryColor: AppColors.primaryColor,
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryColor,
    foregroundColor: Colors.white,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),

  listTileTheme: const ListTileThemeData(
    iconColor: AppColors.primaryColor,
  ),
  iconTheme: const IconThemeData(
    color: AppColors.textLightColor,
  ),
  primaryIconTheme: const IconThemeData(color: Colors.white),
  // textfield theme
  // inputDecorationTheme: const InputDecorationTheme(
  //   enabledBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: AppColors.primaryGray,
  //     ),
  //   ),
  //   errorBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: AppColors.primaryRed,
  //     ),
  //   ),
  //   focusedErrorBorder: UnderlineInputBorder(
  //     borderSide: BorderSide(
  //       color: AppColors.primaryRed,
  //     ),
  //   ),
  // ),
);
