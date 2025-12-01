import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class AppCustomInputDecoTheme {
  static InputDecorationTheme lightInputDecoTheme = InputDecorationTheme(
    prefixIconConstraints: BoxConstraints(minWidth: 25, minHeight: 25),
    errorMaxLines: 3,
    prefixIconColor: Colors.grey.shade500,
    suffixIconColor: Colors.grey.shade500,
    labelStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: AppColors.subTextcolor,
      fontWeight: FontWeight.w400,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 16,
      color: AppColors.subTextcolor,
      fontWeight: FontWeight.w400,
    ),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.normal,
      color: Colors.white,
    ),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.white),

    //used, when no other is specified but overriden by other states
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.lightBackgroundColor),
    ),
    //normal states
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.lightBackgroundColor),
    ),
    //when it receives focus or user taps on it
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.appPrimaryColor),
    ),
    // When validation fails
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    // When error + focused
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 2, color: Colors.orange),
    ),

    //when enabled is set to true, this is used
    // disabledBorder:
  );

  static InputDecorationTheme darkInputDecoTheme = InputDecorationTheme(
    prefixIconConstraints: const BoxConstraints(minWidth: 25, minHeight: 25),
    errorMaxLines: 3,
    prefixIconColor: Colors.grey.shade400,
    suffixIconColor: Colors.grey.shade400,
    labelStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: AppColors.subTextcolor.withAlpha(
        180,
      ), // Consider using a brighter shade if needed
      fontWeight: FontWeight.w400,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 14,
      color: AppColors.boldTextColor,
      fontWeight: FontWeight.w400,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.white70),

    // Default border
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: Colors.grey.withAlpha(251)),
    ),
    // Normal state
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: Colors.grey.withAlpha(251)),
    ),
    // When focused
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 1, color: AppColors.appPrimaryColor),
    ),
    // When validation fails
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(width: 1, color: Colors.red),
    ),
    // When error + focused
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(width: 2, color: Colors.orange),
    ),
  );
}
