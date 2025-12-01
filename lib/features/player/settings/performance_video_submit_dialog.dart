import 'package:flutter/material.dart';
import 'package:next_kick/common/colors/app_colors.dart';
import 'package:next_kick/common/widgets/app_button.dart';
import 'package:next_kick/common/widgets/app_text_form_field.dart';
import 'package:next_kick/utilities/constants/app_image_strings.dart';
import 'package:next_kick/utilities/constants/app_text_strings.dart';
import 'package:next_kick/utilities/extensions/app_extensions.dart';

class PerformanceVideoSubmitDialog extends StatelessWidget {
  final TextEditingController textController;
  final void Function(String link)? onSubmit;
  const PerformanceVideoSubmitDialog({
    super.key,
    required this.textController,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
            image: AssetImage(AppImageStrings.darkSphere),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              AppColors.boldTextColor.withOpacity(0.4),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppTextStrings.performanceVideoUpperCase,
              style: context.textTheme.titleLarge?.copyWith(
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.subTextcolor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppTextStrings.link,
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.appBGColor,
                    ),
                  ),
                  AppTextFormField(
                    hintText: 'Enter your performance video link',
                    textController: textController,
                    obscure: false,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            AppButton(
              label: AppTextStrings.submit,
              backgroundColor: AppColors.appBGColor,
              textColor: AppColors.boldTextColor,
              onButtonPressed: () {
                final link = textController.text.trim();
                if (onSubmit != null) onSubmit!(link);
              },
            ),
          ],
        ),
      ),
    );
  }
}
