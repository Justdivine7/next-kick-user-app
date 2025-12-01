import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class NextKickLightBackground extends StatelessWidget {
  final Widget child;
  final String image;
  final AlignmentGeometry alignment;
  const NextKickLightBackground({
    super.key,
    required this.child,
    required this.image,
    required this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppColors.lightBackgroundColor,
        image: DecorationImage(
          image: AssetImage(image),
          fit: BoxFit.contain,
          alignment: alignment,
        ),
      ),
      child: child,
    );
  }
}
