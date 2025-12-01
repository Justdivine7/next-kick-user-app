  import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class AppCustomCheckBoxTheme {
  static CheckboxThemeData lightCustomCheckBoxTeam = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    checkColor: WidgetStateProperty.resolveWith<Color?>(
      (state) => state.contains(WidgetState.selected) ? Colors.white : null,
    ),

    side: WidgetStateBorderSide.resolveWith(
      (state) =>
          state.contains(WidgetState.selected)
              ? BorderSide(color: AppColors.appPrimaryColor)
              : BorderSide(color: AppColors.appBorderColor),
    ),

    fillColor: WidgetStateProperty.resolveWith<Color>(
      (state) =>
          state.contains(WidgetState.selected)
              ? AppColors.appPrimaryColor
              : Colors.white,
    ),
  );

  static CheckboxThemeData darkCustomCheckBoxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),

    checkColor: WidgetStateProperty.resolveWith<Color?>(
      (state) => state.contains(WidgetState.selected) ? Colors.white : null,
    ),

    side: WidgetStateBorderSide.resolveWith(
      (state) =>
          state.contains(WidgetState.selected)
              ? BorderSide(color: AppColors.appPrimaryColor)
              : BorderSide(color: Colors.grey.shade700),
    ),

    fillColor: WidgetStateProperty.resolveWith<Color>(
      (state) =>
          state.contains(WidgetState.selected)
              ? AppColors.appPrimaryColor
              : Colors.white,
    ),
  );
}
