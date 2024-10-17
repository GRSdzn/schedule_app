import 'package:flutter/material.dart';
import 'package:schedule_app/core/constants/theme/src/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onTitleTap; // Callback for when the title is tapped

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onTitleTap, // Add this to handle tap events
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0, // Set height to make the background smaller
      decoration: BoxDecoration(
        color: AppColors.primaryBackground, // Background color of the AppBar
        borderRadius:
            const BorderRadius.vertical(bottom: Radius.circular(30.0)),
      ),
      child: AppBar(
        title: GestureDetector(
          onTap: onTitleTap, // Assign the tap callback
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize =>
      const Size.fromHeight(60.0); // Set AppBar height to match the Container
}
