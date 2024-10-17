// Основные стили кнопок
import 'package:flutter/material.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';

class AppButtonStyles {
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: Colors.white,
    foregroundColor: AppColors.primaryColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
