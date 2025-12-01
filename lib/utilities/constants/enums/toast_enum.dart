import 'package:flutter/cupertino.dart';
import 'package:next_kick/common/colors/app_colors.dart';

enum ToastStyle {
  success(
    CupertinoIcons.check_mark_circled,
    AppColors.lightGreenBackground,
    AppColors.lightGreenShadowColor,
    AppColors.appPrimaryColor,
  ),
  warning(
    CupertinoIcons.exclamationmark_circle,
    AppColors.lightOrangeBackground,
    AppColors.lightOrangeShadowColor,
    AppColors.solidOrange,
  ),
  error(
    CupertinoIcons.exclamationmark,

    AppColors.lightRedBackground,
    AppColors.lightRedShadowColor,
    AppColors.pastelRed,
  );

  final IconData iconData;
  final Color backgroundColor;
  final Color shadowColor;
  final Color iconContainerColor;
  const ToastStyle(
    this.iconData,
    this.backgroundColor,
    this.shadowColor,
    this.iconContainerColor,
  );
}
