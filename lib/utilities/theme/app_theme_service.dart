import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/utilities/theme/custom_check_box_theme.dart';
import 'package:next_kick/utilities/theme/custom_icon_button_theme.dart';
import 'package:next_kick/utilities/theme/custom_input_decoration_theme.dart';
import 'package:next_kick/utilities/theme/text_theme.dart';

class AppThemeService {
  //light theme
  final ThemeData _lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.appBGColor,
    appBarTheme: AppBarTheme(backgroundColor: Colors.white),
    brightness: Brightness.light,
    fontFamily: "Lexend",
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.appPrimaryColor),
    textTheme: AppTextTheme.lightTextTheme,
    inputDecorationTheme: AppCustomInputDecoTheme.lightInputDecoTheme,
    checkboxTheme: AppCustomCheckBoxTheme.lightCustomCheckBoxTeam,
    iconButtonTheme: AppCustomIconButtonTheme.lightIconTheme,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );

  //dark theme
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: "Lexend",
    scaffoldBackgroundColor: AppColors.solidblack,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.appPrimaryColor,
      brightness: Brightness.dark,
    ),
    appBarTheme: AppBarTheme(backgroundColor: AppColors.solidblack),
    textTheme: AppTextTheme.darkTextTheme,
    inputDecorationTheme: AppCustomInputDecoTheme.darkInputDecoTheme,
    checkboxTheme: AppCustomCheckBoxTheme.darkCustomCheckBoxTheme,
    iconButtonTheme: AppCustomIconButtonTheme.darkIconTheme,
    splashFactory: NoSplash.splashFactory,
    highlightColor: Colors.transparent,
  );

  ThemeData get lighttheme => _lightTheme;
  ThemeData get darkTheme => _darkTheme;
}
