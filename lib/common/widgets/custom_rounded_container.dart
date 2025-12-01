 import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';

class CustomRoundedEdgedContainer extends StatelessWidget {
  final double? width, height, paddingNumber, borderRadius;
  final Color? color, borderColor;
  final bool showBorder;
  final AlignmentGeometry? alignment;
  final Widget child;
  final double borderWidth;
  final Border? border;
  final EdgeInsetsGeometry? margin, padding;
  final List<BoxShadow>? boxShadow;
  final BoxShape? boxShape;
  final VoidCallback? onTap;
  final DecorationImage? decorationImage;
  const CustomRoundedEdgedContainer({
    super.key,
    this.borderRadius,
    this.color,
    this.showBorder = true,
    this.width,
    this.height,
    this.paddingNumber,
    required this.child,
    this.borderWidth = 1.0,
    this.alignment,
    this.borderColor,
    this.margin,
    this.padding,
    this.boxShadow,
    this.border,
    this.boxShape,
    this.onTap,
    this.decorationImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        alignment: alignment,
        height: height,
        width: width,
        padding: padding ?? EdgeInsets.all(paddingNumber ?? 20.0),
        decoration: BoxDecoration(
          image: decorationImage,
          shape: boxShape ?? BoxShape.rectangle,
          borderRadius:
              boxShape != null
                  ? null
                  : BorderRadius.circular(borderRadius ?? 15.0),
          color: color ?? AppColors.appBGColor,
          boxShadow: boxShadow,
          border:
              border ??
              (showBorder
                  ? Border.all(
                    color: borderColor ?? AppColors.borderColor2,
                    width: borderWidth,
                  )
                  : null),
        ),
        child: child,
      ),
    );
  }
}
