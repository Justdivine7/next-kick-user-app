import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/custom_rounded_container.dart';
import 'package:next_kick/utilities/constants/enums/toast_enum.dart';

class ToastContainer extends StatelessWidget {
  final String message;
  final ToastStyle style;
  const ToastContainer({super.key, required this.message, required this.style});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return CustomRoundedEdgedContainer(
      color: style.backgroundColor,
      padding: EdgeInsets.all(8),
      boxShadow: [
        BoxShadow(
          color: style.shadowColor,
          blurRadius: 6,
          offset: Offset(0, 4),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(
            message,
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.boldTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
