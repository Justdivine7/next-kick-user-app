import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class DarkBackground extends StatelessWidget {
  final Widget child;
  const DarkBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBackgroundGradient,
            AppColors.lightBackgroundGradient,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        image: DecorationImage(
          image: AssetImage('assets/images/man-logo-dark.png'),
          fit: BoxFit.contain,
          alignment: Alignment.center,
        ),
      ),
      child: child,
    );
  }
}
