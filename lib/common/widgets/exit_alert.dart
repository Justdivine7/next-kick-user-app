import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class ExitAlert extends StatelessWidget {
  const ExitAlert({super.key});

  @override
  Widget build(BuildContext context) {
    // Completely override dialog theme regardless of parent context
    final forcedTheme = ThemeData(
      colorScheme: ColorScheme.dark(
        surface: AppColors.darkBackgroundGradient,
        primary: AppColors.whiteColor,
      ),
      textTheme: Theme.of(context).textTheme.copyWith(
        titleLarge: TextStyle(
          color: AppColors.whiteColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        bodyLarge: TextStyle(color: AppColors.whiteColor, fontSize: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.lightBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
      ), dialogTheme: DialogThemeData(backgroundColor: AppColors.darkBackgroundGradient),
    );

    return Theme(
      data: forcedTheme, // This overrides everything above it
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Exit App?', style: TextStyle(color: AppColors.whiteColor)),
        content: Text(
          'Are you sure you want to exit?',
          style: TextStyle(color: AppColors.whiteColor),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 8, right: 8),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              'Cancel',
              style: TextStyle(color: AppColors.boldTextColor),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              'Exit',
              style: TextStyle(color: AppColors.boldTextColor),
            ),
          ),
        ],
      ),
    );
  }
}
