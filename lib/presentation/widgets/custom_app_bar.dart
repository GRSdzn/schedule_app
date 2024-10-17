import 'dart:ui'; // Для BackdropFilter
import 'package:flutter/material.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onTitleTap;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onTitleTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30.0)),
      child: BackdropFilter(
        filter: ImageFilter.blur(
            sigmaX: 10.0, sigmaY: 10.0), // Устанавливаем эффект размытия
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryBackground
                .withOpacity(0.8), // Полупрозрачный фон
            borderRadius:
                const BorderRadius.vertical(bottom: Radius.circular(30.0)),
          ),
          child: AppBar(
            // Убираем цвет фона у AppBar
            backgroundColor: Colors.transparent,
            title: GestureDetector(
              onTap: onTitleTap,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
