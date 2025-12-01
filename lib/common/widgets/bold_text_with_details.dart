import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class BoldTextWithDetails extends StatelessWidget {
  final String label;
  final String details;
  final Color backgroundColor;
  final Color labelColor;
  final Color detailsTextColor;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  const BoldTextWithDetails({
    super.key,
    required this.label,
    required this.details,
    required this.backgroundColor,
    required this.labelColor,
    required this.detailsTextColor,
    this.onTap,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
       
        children: [
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: context.textTheme.displayLarge?.copyWith(
                color: labelColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 8),
          SizedBox(
            width: 230.w,
            child: Text(
              textAlign: TextAlign.center,
              details,
              style: context.textTheme.bodyLarge?.copyWith(
                color: detailsTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
