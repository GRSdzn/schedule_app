import 'package:flutter/material.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';

class InputDecorationStyle {
  static const InputDecorationTheme primaryTextField = InputDecorationTheme(
    hintStyle: TextStyle(color: Colors.grey), // Hint text color
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primaryLightGray,
        width: 2.0, // Width for the focused underline
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: AppColors.primaryLightGray,
        width: 0.0, // Match this width with focused border
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red), // Define error state
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide:
          BorderSide(color: Colors.redAccent), // Define focused error state
    ),
    suffixIconColor: AppColors.primaryLightGray,
    prefixIconColor: Colors.blue,
    filled: true,
    fillColor: AppColors.primaryLightGray,
    iconColor: AppColors.primaryGray,
    contentPadding: EdgeInsets.symmetric(
      vertical: 10.0,
      horizontal: 10.0,
    ), // Adjust padding here
  );
}
