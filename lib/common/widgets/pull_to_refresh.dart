 import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class PullToRefresh extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  const PullToRefresh({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      displacement: 40,
      strokeWidth: 2.5,
      backgroundColor: AppColors.appBGColor,
      color: AppColors.appPrimaryColor,
      child: child,
    );
  }
}
