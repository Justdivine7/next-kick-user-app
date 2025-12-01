import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class AppTextTheme {
  static final TextTheme lightTextTheme = TextTheme(
    //bold: 700
    displayLarge: const TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w800,
      color: AppColors.whiteColor,
    ),
    displayMedium: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: AppColors.boldTextColor,
    ),
    displaySmall: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: AppColors.boldTextColor,
    ),

    //semi-bold 600
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w600,
      color: AppColors.boldTextColor,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: AppColors.boldTextColor,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: AppColors.boldTextColor,
    ),

    //medium 500
    titleLarge: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: AppColors.boldTextColor,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: AppColors.boldTextColor,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: AppColors.boldTextColor,
    ),

    //regular 400
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: AppColors.boldTextColor,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: AppColors.boldTextColor,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: AppColors.boldTextColor,
    ),
  );

  //
  static final TextTheme darkTextTheme = TextTheme(
    //bold
    displayLarge: const TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displayMedium: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displaySmall: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),

    //semi-bold
    headlineLarge: const TextStyle().copyWith(
      fontSize: 32.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineMedium: const TextStyle().copyWith(
      fontSize: 24.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    headlineSmall: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),

    //medium
    titleLarge: const TextStyle().copyWith(
      fontSize: 20.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleMedium: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    titleSmall: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),

    //regular
    bodyLarge: const TextStyle().copyWith(
      fontSize: 16.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: const TextStyle().copyWith(
      fontSize: 14.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodySmall: const TextStyle().copyWith(
      fontSize: 12.0,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  );
}
