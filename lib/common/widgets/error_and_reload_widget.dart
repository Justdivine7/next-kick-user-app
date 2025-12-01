import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_button.dart';

class ErrorAndReloadWidget extends StatelessWidget {
  final String errorTitle;
  final Widget? icon;
  final String errorDetails;
  final String? labelText;
  final void Function()? buttonPressed;
  const ErrorAndReloadWidget({
    super.key,
    this.icon,
    required this.errorTitle,
    required this.errorDetails,
    this.labelText,
    this.buttonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon != null
                ? icon!
                : const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              errorTitle,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.subTextcolor),
            ),
            const SizedBox(height: 8),
            Text(
              errorDetails,
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.subTextcolor),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: labelText ?? 'Retry',
              backgroundColor: AppColors.appPrimaryColor,
              textColor: AppColors.appBGColor,
              onButtonPressed: buttonPressed,
            ),
          ],
        ),
      ),
    );
  }
}
