import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_button.dart';

class AppBackButton extends StatelessWidget {
  /// Optional callback when back button is pressed
  final VoidCallback? onBackPressed;

  const AppBackButton({super.key, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: GestureDetector(
        onTap: () {
          if (onBackPressed != null) {
            onBackPressed!();
          } else {
            Navigator.pop(context);
          }
        },
        child: SizedBox(
          width: 90.w,
          child: AppButton(
            label: 'Back',
            backgroundColor: AppColors.darkBackButton,
            textColor: AppColors.whiteColor,
          ),
        ),
      ),
    );
  }
}
